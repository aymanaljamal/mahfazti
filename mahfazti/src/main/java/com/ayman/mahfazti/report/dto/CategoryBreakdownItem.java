package com.ayman.mahfazti.report.dto;

import java.math.BigDecimal;

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
public class CategoryBreakdownItem {

    private Long categoryId;
    private String categoryName;
    private String categoryIcon;
    private BigDecimal totalAmount;
    private double percentage;
}
