package com.ayman.mahfazti.report.dto;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MonthlyReportResponse {

    private int year;
    private int month;
    private BigDecimal totalIncome;
    private BigDecimal totalExpenses;
    private BigDecimal remainingBalance;
    private BigDecimal averageDailySpending;
    private List<CategoryBreakdownItem> categoryBreakdown;
    private BigDecimal previousMonthTotalExpenses;
    private double percentChangeFromPreviousMonth;
    // Filled in once the Budget module exists — null until then.
    private Double overallBudgetUsagePercent;
}
