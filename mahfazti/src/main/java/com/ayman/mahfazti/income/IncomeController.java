
package com.ayman.mahfazti.income;

import java.time.LocalDate;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.ayman.mahfazti.common.response.ApiResponse;
import com.ayman.mahfazti.income.dto.CreateIncomeRequest;
import com.ayman.mahfazti.income.dto.IncomeResponse;
import com.ayman.mahfazti.income.dto.UpdateIncomeRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/incomes")
@RequiredArgsConstructor
public class IncomeController {

    private final IncomeService incomeService;

    @PostMapping
    public ResponseEntity<ApiResponse<IncomeResponse>> createIncome(
            Authentication authentication,
            @Valid @RequestBody CreateIncomeRequest request) {

        IncomeResponse response = incomeService.createIncome(
                authentication.getName(),
                request
        );

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        "Income created successfully",
                        response
                ));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<IncomeResponse>>> getIncomes(
            Authentication authentication,
            @RequestParam(required = false) LocalDate startDate,
            @RequestParam(required = false) LocalDate endDate) {

        List<IncomeResponse> incomes;

        if (startDate != null && endDate != null) {
            incomes = incomeService.getIncomesByDateRange(
                    authentication.getName(),
                    startDate,
                    endDate
            );
        } else {
            incomes = incomeService.getAllIncomes(
                    authentication.getName()
            );
        }

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Incomes retrieved successfully",
                        incomes
                )
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<IncomeResponse>> getIncomeById(
            Authentication authentication,
            @PathVariable Long id) {

        IncomeResponse response = incomeService.getIncomeById(
                authentication.getName(),
                id
        );

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Income retrieved successfully",
                        response
                )
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<IncomeResponse>> updateIncome(
            Authentication authentication,
            @PathVariable Long id,
            @Valid @RequestBody UpdateIncomeRequest request) {

        IncomeResponse response = incomeService.updateIncome(
                authentication.getName(),
                id,
                request
        );

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Income updated successfully",
                        response
                )
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteIncome(
            Authentication authentication,
            @PathVariable Long id) {

        incomeService.deleteIncome(
                authentication.getName(),
                id
        );

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Income deleted successfully",
                        null
                )
        );
    }
}

