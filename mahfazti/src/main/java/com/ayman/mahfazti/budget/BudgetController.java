
package com.ayman.mahfazti.budget;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.ayman.mahfazti.budget.dto.BudgetResponse;
import com.ayman.mahfazti.budget.dto.CreateBudgetRequest;
import com.ayman.mahfazti.budget.dto.UpdateBudgetRequest;
import com.ayman.mahfazti.common.response.ApiResponse;
import com.ayman.mahfazti.user.UserRepository;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/budgets")
@RequiredArgsConstructor
public class BudgetController {

    private final BudgetService budgetService;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<ApiResponse<BudgetResponse>> create(
            Authentication authentication,
            @Valid @RequestBody CreateBudgetRequest request) {

        Long userId = getUserId(authentication);

        BudgetResponse response =
                budgetService.create(userId, request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(
                        "Budget created successfully",
                        response
                ));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<BudgetResponse>>> getAll(
            Authentication authentication,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {

        Long userId = getUserId(authentication);

        List<BudgetResponse> budgets;

        if (year != null && month != null) {
            budgets = budgetService.getByMonth(
                    userId,
                    year,
                    month
            );
        } else {
            budgets = budgetService.getAll(userId);
        }

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Budgets retrieved successfully",
                        budgets
                )
        );
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<BudgetResponse>> getById(
            Authentication authentication,
            @PathVariable Long id) {

        Long userId = getUserId(authentication);

        BudgetResponse response =
                budgetService.getById(userId, id);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Budget retrieved successfully",
                        response
                )
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<BudgetResponse>> update(
            Authentication authentication,
            @PathVariable Long id,
            @Valid @RequestBody UpdateBudgetRequest request) {

        Long userId = getUserId(authentication);

        BudgetResponse response =
                budgetService.update(
                        userId,
                        id,
                        request
                );

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Budget updated successfully",
                        response
                )
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(
            Authentication authentication,
            @PathVariable Long id) {

        Long userId = getUserId(authentication);

        budgetService.delete(userId, id);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Budget deleted successfully",
                        null
                )
        );
    }

    private Long getUserId(Authentication authentication) {

        return userRepository
                .findByEmail(authentication.getName())
                .orElseThrow(() ->
                        new RuntimeException("User not found"))
                .getId();
    }
}

