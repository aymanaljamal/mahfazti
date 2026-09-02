
package com.ayman.mahfazti.income.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.ayman.mahfazti.common.enums.IncomeSource;

public record IncomeResponse(
        Long id,
        BigDecimal amount,
        IncomeSource source,
        LocalDate date,
        String description,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}

