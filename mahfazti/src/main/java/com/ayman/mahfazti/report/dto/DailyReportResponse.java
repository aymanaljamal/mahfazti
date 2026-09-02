package com.ayman.mahfazti.report.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
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
public class DailyReportResponse {

    private LocalDate date;
    private BigDecimal totalExpenses;
    private BigDecimal totalIncome;
    private int transactionCount;
    private ExpenseHighlight highestExpense;
    private List<CategoryBreakdownItem> categoryBreakdown;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ExpenseHighlight {
        private Long expenseId;
        private BigDecimal amount;
        private String categoryName;
        private String description;
    }
}
