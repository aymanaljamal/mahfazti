package com.ayman.mahfazti.expense.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import com.ayman.mahfazti.common.enums.PaymentMethod;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * All fields are optional here — only non-null fields will be applied
 * during the update (partial update / PATCH-style behaviour).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateExpenseRequest {

    @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
    private BigDecimal amount;

    private Long categoryId;

    private LocalDate date;

    private LocalTime time;

    private PaymentMethod paymentMethod;

    @Size(max = 255, message = "Description must not exceed 255 characters")
    private String description;
}
