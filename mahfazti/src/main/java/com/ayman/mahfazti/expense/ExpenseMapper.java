package com.ayman.mahfazti.expense;

import java.time.LocalTime;
import java.util.List;

import org.springframework.stereotype.Component;

import com.ayman.mahfazti.category.Category;
import com.ayman.mahfazti.expense.dto.CreateExpenseRequest;
import com.ayman.mahfazti.expense.dto.ExpenseResponse;
import com.ayman.mahfazti.expense.dto.UpdateExpenseRequest;
import com.ayman.mahfazti.user.User;

@Component
public class ExpenseMapper {

    public Expense toEntity(CreateExpenseRequest request, User user, Category category) {
        return Expense.builder()
                .user(user)
                .category(category)
                .amount(request.getAmount())
                .date(request.getDate())
                .time(request.getTime() != null ? request.getTime() : LocalTime.now())
                .paymentMethod(request.getPaymentMethod())
                .description(request.getDescription())
                .build();
    }

    public void updateEntity(Expense expense, UpdateExpenseRequest request, Category category) {
        if (request.getAmount() != null) {
            expense.setAmount(request.getAmount());
        }
        if (category != null) {
            expense.setCategory(category);
        }
        if (request.getDate() != null) {
            expense.setDate(request.getDate());
        }
        if (request.getTime() != null) {
            expense.setTime(request.getTime());
        }
        if (request.getPaymentMethod() != null) {
            expense.setPaymentMethod(request.getPaymentMethod());
        }
        if (request.getDescription() != null) {
            expense.setDescription(request.getDescription());
        }
    }

    public ExpenseResponse toResponse(Expense expense) {
        if (expense == null) {
            return null;
        }

        Category category = expense.getCategory();

        return ExpenseResponse.builder()
                .id(expense.getId())
                .amount(expense.getAmount())
                .categoryId(category != null ? category.getId() : null)
                .categoryName(category != null ? category.getName() : null)
                .categoryIcon(category != null ? category.getIcon() : null)
                .date(expense.getDate())
                .time(expense.getTime())
                .paymentMethod(expense.getPaymentMethod())
                .description(expense.getDescription())
                .createdAt(expense.getCreatedAt())
                .updatedAt(expense.getUpdatedAt())
                .build();
    }

    public List<ExpenseResponse> toResponseList(List<Expense> expenses) {
        return expenses.stream().map(this::toResponse).toList();
    }
}
