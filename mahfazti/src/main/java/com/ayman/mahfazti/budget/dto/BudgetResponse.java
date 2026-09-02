
package com.ayman.mahfazti.budget.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record BudgetResponse(
        Long id,
        Long categoryId,
        String categoryName,
        String categoryIcon,
        BigDecimal amount,
        Integer year,
        Integer month,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}

