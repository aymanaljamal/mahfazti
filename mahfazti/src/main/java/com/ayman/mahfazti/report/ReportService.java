package com.ayman.mahfazti.report;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ayman.mahfazti.budget.Budget;
import com.ayman.mahfazti.budget.BudgetRepository;
import com.ayman.mahfazti.expense.Expense;
import com.ayman.mahfazti.expense.ExpenseRepository;
import com.ayman.mahfazti.income.IncomeRepository;
import com.ayman.mahfazti.report.dto.CategoryBreakdownItem;
import com.ayman.mahfazti.report.dto.DailyReportResponse;
import com.ayman.mahfazti.report.dto.MonthlyReportResponse;
import com.ayman.mahfazti.report.dto.WeeklyReportResponse;
import com.ayman.mahfazti.report.dto.YearlyReportResponse;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ExpenseRepository expenseRepository;
    private final IncomeRepository incomeRepository;
    private final BudgetRepository budgetRepository;

    // =========================================================
    // DAILY
    // =========================================================

    @Transactional(readOnly = true)
    public DailyReportResponse getDailyReport(
            Long userId,
            LocalDate date) {

        List<Expense> expenses =
                expenseRepository.findByUserIdAndDateOrderByAmountDesc(
                        userId,
                        date
                );

        BigDecimal totalExpenses = expenses.stream()
                .map(Expense::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalIncome =
                incomeRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        date,
                        date
                );

        DailyReportResponse.ExpenseHighlight highlight =
                expenses.isEmpty()
                        ? null
                        : DailyReportResponse.ExpenseHighlight.builder()
                                .expenseId(expenses.get(0).getId())
                                .amount(expenses.get(0).getAmount())
                                .categoryName(
                                        expenses.get(0)
                                                .getCategory()
                                                .getName()
                                )
                                .description(
                                        expenses.get(0)
                                                .getDescription()
                                )
                                .build();

        return DailyReportResponse.builder()
                .date(date)
                .totalExpenses(totalExpenses)
                .totalIncome(totalIncome)
                .transactionCount(expenses.size())
                .highestExpense(highlight)
                .categoryBreakdown(
                        buildCategoryBreakdown(
                                userId,
                                date,
                                date,
                                totalExpenses
                        )
                )
                .build();
    }

    // =========================================================
    // WEEKLY
    // =========================================================

    @Transactional(readOnly = true)
    public WeeklyReportResponse getWeeklyReport(
            Long userId,
            LocalDate anyDateInWeek) {

        LocalDate weekStart =
                anyDateInWeek.minusDays(
                        anyDateInWeek.getDayOfWeek().getValue() - 1
                );

        LocalDate weekEnd =
                weekStart.plusDays(6);

        LocalDate previousWeekStart =
                weekStart.minusWeeks(1);

        LocalDate previousWeekEnd =
                weekEnd.minusWeeks(1);

        BigDecimal totalExpenses =
                expenseRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        weekStart,
                        weekEnd
                );

        BigDecimal previousWeekTotal =
                expenseRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        previousWeekStart,
                        previousWeekEnd
                );

        BigDecimal averageDailySpending =
                totalExpenses.divide(
                        BigDecimal.valueOf(7),
                        2,
                        RoundingMode.HALF_UP
                );

        WeeklyReportResponse.DaySpending highestDay =
                findHighestSpendingDay(
                        userId,
                        weekStart,
                        weekEnd
                );

        String mostExpensiveCategory =
                findTopCategoryName(
                        userId,
                        weekStart,
                        weekEnd
                );

        double percentChange =
                calculatePercentChange(
                        previousWeekTotal,
                        totalExpenses
                );

        return WeeklyReportResponse.builder()
                .weekStart(weekStart)
                .weekEnd(weekEnd)
                .totalExpenses(totalExpenses)
                .averageDailySpending(averageDailySpending)
                .highestSpendingDay(highestDay)
                .mostExpensiveCategory(mostExpensiveCategory)
                .previousWeekTotal(previousWeekTotal)
                .percentChangeFromPreviousWeek(percentChange)
                .build();
    }

    // =========================================================
    // MONTHLY
    // =========================================================

    @Transactional(readOnly = true)
    public MonthlyReportResponse getMonthlyReport(
            Long userId,
            int year,
            int month) {

        YearMonth yearMonth =
                YearMonth.of(year, month);

        LocalDate start =
                yearMonth.atDay(1);

        LocalDate end =
                yearMonth.atEndOfMonth();

        // -----------------------------------------------------
        // Previous month
        // -----------------------------------------------------

        YearMonth previousYearMonth =
                yearMonth.minusMonths(1);

        LocalDate previousStart =
                previousYearMonth.atDay(1);

        LocalDate previousEnd =
                previousYearMonth.atEndOfMonth();

        // -----------------------------------------------------
        // Income
        // -----------------------------------------------------

        BigDecimal totalIncome =
                incomeRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        start,
                        end
                );

        // -----------------------------------------------------
        // Expenses
        // -----------------------------------------------------

        BigDecimal totalExpenses =
                expenseRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        start,
                        end
                );

        BigDecimal previousMonthExpenses =
                expenseRepository.sumAmountByUserIdAndDateBetween(
                        userId,
                        previousStart,
                        previousEnd
                );

        // -----------------------------------------------------
        // Balance
        // -----------------------------------------------------

        BigDecimal remainingBalance =
                totalIncome.subtract(totalExpenses);

        // -----------------------------------------------------
        // Average daily spending
        // -----------------------------------------------------

        BigDecimal averageDailySpending =
                totalExpenses.divide(
                        BigDecimal.valueOf(
                                yearMonth.lengthOfMonth()
                        ),
                        2,
                        RoundingMode.HALF_UP
                );

        // -----------------------------------------------------
        // Percentage change
        // -----------------------------------------------------

        double percentChange =
                calculatePercentChange(
                        previousMonthExpenses,
                        totalExpenses
                );

        // -----------------------------------------------------
        // Budget usage
        // -----------------------------------------------------

        Double overallBudgetUsagePercent =
                calculateOverallBudgetUsage(
                        userId,
                        year,
                        month,
                        totalExpenses
                );

        // -----------------------------------------------------
        // Response
        // -----------------------------------------------------

        return MonthlyReportResponse.builder()
                .year(year)
                .month(month)
                .totalIncome(totalIncome)
                .totalExpenses(totalExpenses)
                .remainingBalance(remainingBalance)
                .averageDailySpending(averageDailySpending)
                .categoryBreakdown(
                        buildCategoryBreakdown(
                                userId,
                                start,
                                end,
                                totalExpenses
                        )
                )
                .previousMonthTotalExpenses(
                        previousMonthExpenses
                )
                .percentChangeFromPreviousMonth(
                        percentChange
                )
                .overallBudgetUsagePercent(
                        overallBudgetUsagePercent
                )
                .build();
    }

    // =========================================================
    // YEARLY
    // =========================================================

    @Transactional(readOnly = true)
    public YearlyReportResponse getYearlyReport(
            Long userId,
            int year) {

        List<YearlyReportResponse.MonthSpending> monthlyBreakdown =
                new ArrayList<>();

        BigDecimal yearTotalExpenses =
                BigDecimal.ZERO;

        BigDecimal yearTotalIncome =
                BigDecimal.ZERO;

        for (int month = 1; month <= 12; month++) {

            YearMonth yearMonth =
                    YearMonth.of(year, month);

            LocalDate start =
                    yearMonth.atDay(1);

            LocalDate end =
                    yearMonth.atEndOfMonth();

            BigDecimal monthExpenses =
                    expenseRepository.sumAmountByUserIdAndDateBetween(
                            userId,
                            start,
                            end
                    );

            BigDecimal monthIncome =
                    incomeRepository.sumAmountByUserIdAndDateBetween(
                            userId,
                            start,
                            end
                    );

            yearTotalExpenses =
                    yearTotalExpenses.add(monthExpenses);

            yearTotalIncome =
                    yearTotalIncome.add(monthIncome);

            monthlyBreakdown.add(
                    YearlyReportResponse.MonthSpending.builder()
                            .month(month)
                            .monthName(
                                    yearMonth.getMonth()
                                            .getDisplayName(
                                                    TextStyle.FULL,
                                                    new Locale("en")
                                            )
                            )
                            .totalExpenses(monthExpenses)
                            .totalIncome(monthIncome)
                            .build()
            );
        }

        return YearlyReportResponse.builder()
                .year(year)
                .totalIncome(yearTotalIncome)
                .totalExpenses(yearTotalExpenses)
                .monthlyBreakdown(monthlyBreakdown)
                .build();
    }

    // =========================================================
    // CALCULATE OVERALL MONTHLY BUDGET USAGE
    // =========================================================

    private Double calculateOverallBudgetUsage(
            Long userId,
            int year,
            int month,
            BigDecimal totalExpenses) {

        List<Budget> budgets =
                budgetRepository.findByUserIdAndYearAndMonth(
                        userId,
                        year,
                        month
                );

        // No budgets configured for this month
        if (budgets.isEmpty()) {
            return null;
        }

        BigDecimal totalBudget =
                budgets.stream()
                        .map(Budget::getAmount)
                        .reduce(
                                BigDecimal.ZERO,
                                BigDecimal::add
                        );

        // Prevent division by zero
        if (totalBudget.compareTo(BigDecimal.ZERO) == 0) {
            return 0.0;
        }

        return totalExpenses
                .divide(
                        totalBudget,
                        4,
                        RoundingMode.HALF_UP
                )
                .multiply(BigDecimal.valueOf(100))
                .setScale(2, RoundingMode.HALF_UP)
                .doubleValue();
    }

    // =========================================================
    // CATEGORY BREAKDOWN
    // =========================================================

    private List<CategoryBreakdownItem> buildCategoryBreakdown(
            Long userId,
            LocalDate start,
            LocalDate end,
            BigDecimal total) {

        List<Object[]> rows =
                expenseRepository.sumAmountGroupByCategory(
                        userId,
                        start,
                        end
                );

        List<CategoryBreakdownItem> items =
                new ArrayList<>();

        for (Object[] row : rows) {

            Long categoryId =
                    (Long) row[0];

            String categoryName =
                    (String) row[1];

            String categoryIcon =
                    (String) row[2];

            BigDecimal amount =
                    (BigDecimal) row[3];

            double percentage =
                    total.compareTo(BigDecimal.ZERO) == 0
                            ? 0
                            : amount
                                    .divide(
                                            total,
                                            4,
                                            RoundingMode.HALF_UP
                                    )
                                    .multiply(
                                            BigDecimal.valueOf(100)
                                    )
                                    .doubleValue();

            items.add(
                    CategoryBreakdownItem.builder()
                            .categoryId(categoryId)
                            .categoryName(categoryName)
                            .categoryIcon(categoryIcon)
                            .totalAmount(amount)
                            .percentage(percentage)
                            .build()
            );
        }

        return items;
    }

    // =========================================================
    // HIGHEST SPENDING DAY
    // =========================================================

    private WeeklyReportResponse.DaySpending findHighestSpendingDay(
            Long userId,
            LocalDate weekStart,
            LocalDate weekEnd) {

        LocalDate highestDate = null;

        BigDecimal highestAmount =
                BigDecimal.ZERO;

        for (
                LocalDate d = weekStart;
                !d.isAfter(weekEnd);
                d = d.plusDays(1)
        ) {

            BigDecimal dayTotal =
                    expenseRepository.sumAmountByUserIdAndDateBetween(
                            userId,
                            d,
                            d
                    );

            if (dayTotal.compareTo(highestAmount) > 0) {
                highestAmount = dayTotal;
                highestDate = d;
            }
        }

        if (highestDate == null) {
            return null;
        }

        return WeeklyReportResponse.DaySpending.builder()
                .date(highestDate)
                .amount(highestAmount)
                .build();
    }

    // =========================================================
    // TOP CATEGORY
    // =========================================================

    private String findTopCategoryName(
            Long userId,
            LocalDate start,
            LocalDate end) {

        List<Object[]> rows =
                expenseRepository.sumAmountGroupByCategory(
                        userId,
                        start,
                        end
                );

        if (rows.isEmpty()) {
            return null;
        }

        return (String) rows.get(0)[1];
    }

    // =========================================================
    // PERCENT CHANGE
    // =========================================================

    private double calculatePercentChange(
            BigDecimal previous,
            BigDecimal current) {

        if (previous.compareTo(BigDecimal.ZERO) == 0) {

            return current.compareTo(BigDecimal.ZERO) == 0
                    ? 0
                    : 100;
        }

        return current
                .subtract(previous)
                .divide(
                        previous,
                        4,
                        RoundingMode.HALF_UP
                )
                .multiply(
                        BigDecimal.valueOf(100)
                )
                .doubleValue();
    }
}