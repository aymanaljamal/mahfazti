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
public class YearlyReportResponse {

    private int year;
    private BigDecimal totalIncome;
    private BigDecimal totalExpenses;
    private List<MonthSpending> monthlyBreakdown;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class MonthSpending {
        private int month;
        private String monthName;
        private BigDecimal totalExpenses;
        private BigDecimal totalIncome;
    }
}
