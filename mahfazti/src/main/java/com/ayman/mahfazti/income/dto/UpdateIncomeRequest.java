
package com.ayman.mahfazti.income.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

import com.ayman.mahfazti.common.enums.IncomeSource;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateIncomeRequest(

        @NotNull(message = "Amount is required")
        @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
        BigDecimal amount,

        @NotNull(message = "Income source is required")
        IncomeSource source,

        @NotNull(message = "Date is required")
        LocalDate date,

        @Size(max = 255, message = "Description must not exceed 255 characters")
        String description
) {
}

