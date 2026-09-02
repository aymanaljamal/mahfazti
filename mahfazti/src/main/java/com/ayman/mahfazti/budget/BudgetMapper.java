
package com.ayman.mahfazti.budget;

import org.springframework.stereotype.Component;

import com.ayman.mahfazti.budget.dto.BudgetResponse;

@Component
public class BudgetMapper {

    public BudgetResponse toResponse(Budget budget) {

        return new BudgetResponse(
                budget.getId(),
                budget.getCategory().getId(),
                budget.getCategory().getName(),
                budget.getCategory().getIcon(),
                budget.getAmount(),
                budget.getYear(),
                budget.getMonth(),
                budget.getCreatedAt(),
                budget.getUpdatedAt()
        );
    }
}
