package com.ayman.mahfazti.budget;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ayman.mahfazti.budget.dto.BudgetResponse;
import com.ayman.mahfazti.budget.dto.CreateBudgetRequest;
import com.ayman.mahfazti.budget.dto.UpdateBudgetRequest;
import com.ayman.mahfazti.category.Category;
import com.ayman.mahfazti.category.CategoryRepository;
import com.ayman.mahfazti.common.enums.NotificationType;
import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.expense.ExpenseRepository;
import com.ayman.mahfazti.notification.NotificationService;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BudgetService {

    private final BudgetRepository budgetRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final BudgetMapper budgetMapper;
    private final ExpenseRepository expenseRepository;
    private final NotificationService notificationService;

    // =========================================================
    // CREATE
    // =========================================================

    @Transactional
    public BudgetResponse create(
            Long userId,
            CreateBudgetRequest request) {

        User user = getUserOrThrow(userId);

        Category category =
                getAvailableCategoryOrThrow(
                        request.categoryId(),
                        userId
                );

        boolean exists =
                budgetRepository
                        .existsByUserIdAndCategoryIdAndYearAndMonth(
                                userId,
                                request.categoryId(),
                                request.year(),
                                request.month()
                        );

        if (exists) {
            throw new IllegalArgumentException(
                    "A budget already exists for this category and month"
            );
        }

        Budget budget = Budget.builder()
                .user(user)
                .category(category)
                .amount(request.amount())
                .year(request.year())
                .month(request.month())
                .build();

        return budgetMapper.toResponse(
                budgetRepository.save(budget)
        );
    }

    // =========================================================
    // GET ALL
    // =========================================================

    @Transactional(readOnly = true)
    public List<BudgetResponse> getAll(
            Long userId) {

        return budgetRepository
                .findByUserIdOrderByYearDescMonthDesc(userId)
                .stream()
                .map(budgetMapper::toResponse)
                .toList();
    }

    // =========================================================
    // GET BY MONTH
    // =========================================================

    @Transactional(readOnly = true)
    public List<BudgetResponse> getByMonth(
            Long userId,
            Integer year,
            Integer month) {

        return budgetRepository
                .findByUserIdAndYearAndMonth(
                        userId,
                        year,
                        month
                )
                .stream()
                .map(budgetMapper::toResponse)
                .toList();
    }

    // =========================================================
    // GET BY ID
    // =========================================================

    @Transactional(readOnly = true)
    public BudgetResponse getById(
            Long userId,
            Long budgetId) {

        Budget budget =
                getOwnedBudgetOrThrow(
                        userId,
                        budgetId
                );

        return budgetMapper.toResponse(budget);
    }

    // =========================================================
    // UPDATE
    // =========================================================

    @Transactional
    public BudgetResponse update(
            Long userId,
            Long budgetId,
            UpdateBudgetRequest request) {

        Budget budget =
                getOwnedBudgetOrThrow(
                        userId,
                        budgetId
                );

        Category category =
                getAvailableCategoryOrThrow(
                        request.categoryId(),
                        userId
                );

        /*
         * Check whether another budget already uses
         * the same category/year/month.
         */
        Optional<Budget> existingBudget =
                budgetRepository
                        .findByUserIdAndCategoryIdAndYearAndMonth(
                                userId,
                                request.categoryId(),
                                request.year(),
                                request.month()
                        );

        if (existingBudget.isPresent()
                && !existingBudget.get().getId().equals(budgetId)) {

            throw new IllegalArgumentException(
                    "A budget already exists for this category and month"
            );
        }

        budget.setCategory(category);
        budget.setAmount(request.amount());
        budget.setYear(request.year());
        budget.setMonth(request.month());

        return budgetMapper.toResponse(
                budgetRepository.save(budget)
        );
    }

    // =========================================================
    // DELETE
    // =========================================================

    @Transactional
    public void delete(
            Long userId,
            Long budgetId) {

        Budget budget =
                getOwnedBudgetOrThrow(
                        userId,
                        budgetId
                );

        budgetRepository.delete(budget);
    }

    // =========================================================
    // CHECK BUDGET AFTER EXPENSE
    // =========================================================

    @Transactional
    public void checkBudgetAfterExpense(
            Long userId,
            Long categoryId,
            LocalDate expenseDate,
            BigDecimal previousSpending) {

        int year =
                expenseDate.getYear();

        int month =
                expenseDate.getMonthValue();

        Optional<Budget> budgetOptional =
                budgetRepository
                        .findByUserIdAndCategoryIdAndYearAndMonth(
                                userId,
                                categoryId,
                                year,
                                month
                        );

        // No budget configured
        if (budgetOptional.isEmpty()) {
            return;
        }

        Budget budget =
                budgetOptional.get();

        LocalDate startDate =
                expenseDate.withDayOfMonth(1);

        LocalDate endDate =
                expenseDate.withDayOfMonth(
                        expenseDate.lengthOfMonth()
                );

        BigDecimal currentSpending =
                expenseRepository
                        .sumAmountByUserIdAndCategoryIdAndDateBetween(
                                userId,
                                categoryId,
                                startDate,
                                endDate
                        );

        BigDecimal budgetAmount =
                budget.getAmount();

        if (budgetAmount.compareTo(
                BigDecimal.ZERO) <= 0) {
            return;
        }

        BigDecimal previousPercentage =
                previousSpending
                        .divide(
                                budgetAmount,
                                4,
                                RoundingMode.HALF_UP
                        )
                        .multiply(
                                BigDecimal.valueOf(100)
                        );

        BigDecimal currentPercentage =
                currentSpending
                        .divide(
                                budgetAmount,
                                4,
                                RoundingMode.HALF_UP
                        )
                        .multiply(
                                BigDecimal.valueOf(100)
                        );

        // =====================================================
        // 100% - BUDGET EXCEEDED
        // =====================================================

        if (previousPercentage.compareTo(
                BigDecimal.valueOf(100)) < 0
                && currentPercentage.compareTo(
                BigDecimal.valueOf(100)) >= 0) {

            notificationService.notify(
                    userId,
                    NotificationType.BUDGET_EXCEEDED,
                    "Budget exceeded",
                    "Your "
                            + budget.getCategory().getName()
                            + " budget for "
                            + month
                            + "/"
                            + year
                            + " has been exceeded."
            );

            return;
        }

        // =====================================================
        // 80% - BUDGET WARNING
        // =====================================================

        if (previousPercentage.compareTo(
                BigDecimal.valueOf(80)) < 0
                && currentPercentage.compareTo(
                BigDecimal.valueOf(80)) >= 0) {

            notificationService.notify(
                    userId,
                    NotificationType.BUDGET_WARNING,
                    "Budget warning",
                    "You have used "
                            + currentPercentage.setScale(
                                    2,
                                    RoundingMode.HALF_UP
                            )
                            + "% of your "
                            + budget.getCategory().getName()
                            + " budget for "
                            + month
                            + "/"
                            + year
                            + "."
            );
        }
    }

    // =========================================================
    // GET OWNED BUDGET
    // =========================================================

    private Budget getOwnedBudgetOrThrow(
            Long userId,
            Long budgetId) {

        return budgetRepository
                .findByIdAndUserId(
                        budgetId,
                        userId
                )
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Budget not found with id: "
                                        + budgetId
                        )
                );
    }

    // =========================================================
    // GET USER
    // =========================================================

    private User getUserOrThrow(
            Long userId) {

        return userRepository
                .findById(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User not found with id: "
                                        + userId
                        )
                );
    }

    // =========================================================
    // GET AVAILABLE CATEGORY
    // =========================================================

    private Category getAvailableCategoryOrThrow(
            Long categoryId,
            Long userId) {

        return categoryRepository
                .findAllAvailableForUser(userId)
                .stream()
                .filter(category ->
                        category.getId().equals(categoryId))
                .findFirst()
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Category not found or not available for this user"
                        )
                );
    }
}