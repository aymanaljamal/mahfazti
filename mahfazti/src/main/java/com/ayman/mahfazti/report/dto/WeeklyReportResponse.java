package com.ayman.mahfazti.report.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

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
public class WeeklyReportResponse {

    private LocalDate weekStart;
    private LocalDate weekEnd;
    private BigDecimal totalExpenses;
    private BigDecimal averageDailySpending;
    private DaySpending highestSpendingDay;
    private String mostExpensiveCategory;
    private BigDecimal previousWeekTotal;
    private double percentChangeFromPreviousWeek;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class DaySpending {
        private LocalDate date;
        private BigDecimal amount;
    }
}
