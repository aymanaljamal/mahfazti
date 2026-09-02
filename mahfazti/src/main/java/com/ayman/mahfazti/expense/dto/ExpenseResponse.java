package com.ayman.mahfazti.expense.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import com.ayman.mahfazti.common.enums.PaymentMethod;

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
public class ExpenseResponse {

    private Long id;
    private BigDecimal amount;
    private Long categoryId;
    private String categoryName;
    private String categoryIcon;
    private LocalDate date;
    private LocalTime time;
    private PaymentMethod paymentMethod;
    private String description;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
