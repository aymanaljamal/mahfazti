package com.ayman.mahfazti.expense;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ayman.mahfazti.budget.BudgetService;
import com.ayman.mahfazti.category.Category;
import com.ayman.mahfazti.category.CategoryRepository;
import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.expense.dto.CreateExpenseRequest;
import com.ayman.mahfazti.expense.dto.ExpenseResponse;
import com.ayman.mahfazti.expense.dto.UpdateExpenseRequest;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ExpenseService {

    private final ExpenseRepository expenseRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final ExpenseMapper expenseMapper;
    private final BudgetService budgetService;

    // =========================================================
    // CREATE EXPENSE
    // =========================================================

    @Transactional
    public ExpenseResponse create(
            Long userId,
            CreateExpenseRequest request) {

        User user = getUserOrThrow(userId);

        Category category = getAvailableCategoryOrThrow(
                request.getCategoryId(),
                userId
        );

        Expense expense = expenseMapper.toEntity(
                request,
                user,
                category
        );

        Expense saved = expenseRepository.save(expense);

        // Check budget after creating the expense
        BigDecimal previousSpending = getMonthlyCategorySpending(
                userId,
                category.getId(),
                saved.getDate()
        ).subtract(saved.getAmount());

        budgetService.checkBudgetAfterExpense(
                userId,
                category.getId(),
                saved.getDate(),
                previousSpending
        );

        return expenseMapper.toResponse(saved);
    }

    // =========================================================
    // GET BY ID
    // =========================================================

    @Transactional(readOnly = true)
    public ExpenseResponse getById(
            Long userId,
            Long expenseId) {

        Expense expense = getOwnedExpenseOrThrow(
                userId,
                expenseId
        );

        return expenseMapper.toResponse(expense);
    }

    // =========================================================
    // GET ALL
    // =========================================================

    @Transactional(readOnly = true)
    public List<ExpenseResponse> getAll(
            Long userId) {

        return expenseMapper.toResponseList(
                expenseRepository.findByUserIdOrderByDateDescTimeDesc(
                        userId
                )
        );
    }

    // =========================================================
    // GET BY DATE RANGE
    // =========================================================

    @Transactional(readOnly = true)
    public List<ExpenseResponse> getByDateRange(
            Long userId,
            LocalDate startDate,
            LocalDate endDate) {

        return expenseMapper.toResponseList(
                expenseRepository
                        .findByUserIdAndDateBetweenOrderByDateDescTimeDesc(
                                userId,
                                startDate,
                                endDate
                        )
        );
    }

    // =========================================================
    // GET BY CATEGORY
    // =========================================================

    @Transactional(readOnly = true)
    public List<ExpenseResponse> getByCategory(
            Long userId,
            Long categoryId) {

        // Make sure the category is available to this user
        getAvailableCategoryOrThrow(
                categoryId,
                userId
        );

        return expenseMapper.toResponseList(
                expenseRepository.findByUserIdAndCategoryId(
                        userId,
                        categoryId
                )
        );
    }

    // =========================================================
    // GET TOTAL FOR PERIOD
    // =========================================================

    @Transactional(readOnly = true)
    public BigDecimal getTotalForPeriod(
            Long userId,
            LocalDate startDate,
            LocalDate endDate) {

        return expenseRepository.sumAmountByUserIdAndDateBetween(
                userId,
                startDate,
                endDate
        );
    }

    // =========================================================
    // UPDATE EXPENSE
    // =========================================================

    @Transactional
    public ExpenseResponse update(
            Long userId,
            Long expenseId,
            UpdateExpenseRequest request) {

        Expense expense = getOwnedExpenseOrThrow(
                userId,
                expenseId
        );

        /*
         * Save the old values before modifying the entity.
         * We need them to recalculate the old budget correctly.
         */
        Long oldCategoryId = expense.getCategory().getId();
        LocalDate oldDate = expense.getDate();

        BigDecimal oldAmount = expense.getAmount();

        /*
         * Get the new category.
         * If categoryId is null, keep the existing category.
         */
        Category newCategory = expense.getCategory();

        if (request.getCategoryId() != null) {
            newCategory = getAvailableCategoryOrThrow(
                    request.getCategoryId(),
                    userId
            );
        }

        /*
         * Update the expense.
         */
        expenseMapper.updateEntity(
                expense,
                request,
                newCategory
        );

        Expense saved = expenseRepository.save(expense);

        // =====================================================
        // RECHECK OLD BUDGET
        // =====================================================

        /*
         * If the category/date/amount changed, the old budget
         * may have changed as well.
         *
         * We do not create a new notification when the old
         * spending goes down. We simply allow future expenses
         * to cross the thresholds correctly.
         */

        if (!oldCategoryId.equals(saved.getCategory().getId())
                || !oldDate.equals(saved.getDate())
                || oldAmount.compareTo(saved.getAmount()) != 0) {

            /*
             * If the expense remained in the same category and month,
             * we need to calculate the spending before the updated
             * expense.
             */
            if (oldCategoryId.equals(saved.getCategory().getId())
                    && oldDate.getYear() == saved.getDate().getYear()
                    && oldDate.getMonthValue() == saved.getDate().getMonthValue()) {

                BigDecimal currentSpending =
                        getMonthlyCategorySpending(
                                userId,
                                saved.getCategory().getId(),
                                saved.getDate()
                        );

                BigDecimal previousSpending =
                        currentSpending
                                .subtract(saved.getAmount())
                                .add(oldAmount);

                /*
                 * Check only when the updated expense increased
                 * the spending.
                 */
                if (saved.getAmount().compareTo(oldAmount) > 0) {

                    budgetService.checkBudgetAfterExpense(
                            userId,
                            saved.getCategory().getId(),
                            saved.getDate(),
                            previousSpending
                    );
                }

            } else {

                /*
                 * Category or month changed.
                 *
                 * Check the NEW budget using the spending before
                 * the updated expense.
                 */
                BigDecimal newCurrentSpending =
                        getMonthlyCategorySpending(
                                userId,
                                saved.getCategory().getId(),
                                saved.getDate()
                        );

                BigDecimal newPreviousSpending =
                        newCurrentSpending
                                .subtract(saved.getAmount());

                budgetService.checkBudgetAfterExpense(
                        userId,
                        saved.getCategory().getId(),
                        saved.getDate(),
                        newPreviousSpending
                );
            }
        }

        return expenseMapper.toResponse(saved);
    }

    // =========================================================
    // DELETE EXPENSE
    // =========================================================

    @Transactional
    public void delete(
            Long userId,
            Long expenseId) {

        Expense expense = getOwnedExpenseOrThrow(
                userId,
                expenseId
        );

        expenseRepository.delete(expense);
    }

    // =========================================================
    // GET MONTHLY CATEGORY SPENDING
    // =========================================================

    private BigDecimal getMonthlyCategorySpending(
            Long userId,
            Long categoryId,
            LocalDate date) {

        LocalDate startDate =
                date.withDayOfMonth(1);

        LocalDate endDate =
                date.withDayOfMonth(
                        date.lengthOfMonth()
                );

        return expenseRepository
                .sumAmountByUserIdAndCategoryIdAndDateBetween(
                        userId,
                        categoryId,
                        startDate,
                        endDate
                );
    }

    // =========================================================
    // GET OWNED EXPENSE
    // =========================================================

    private Expense getOwnedExpenseOrThrow(
            Long userId,
            Long expenseId) {

        return expenseRepository
                .findByIdAndUserId(
                        expenseId,
                        userId
                )
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Expense not found with id: "
                                        + expenseId
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