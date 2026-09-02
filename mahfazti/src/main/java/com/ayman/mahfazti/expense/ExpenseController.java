package com.ayman.mahfazti.expense;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.expense.dto.CreateExpenseRequest;
import com.ayman.mahfazti.expense.dto.ExpenseResponse;
import com.ayman.mahfazti.expense.dto.UpdateExpenseRequest;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/expenses")
@RequiredArgsConstructor
public class ExpenseController {

    private final ExpenseService expenseService;
    private final UserRepository userRepository;

    // NOTE: adjust this to match however you already resolve the current user
    // in UserController (e.g. a custom UserDetails/principal). This version
    // resolves it from the authenticated email, the same field used for login.
    private Long currentUserId(Authentication authentication) {
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + email));
        return user.getId();
    }

    @PostMapping
    public ResponseEntity<ExpenseResponse> create(
            Authentication authentication,
            @Valid @RequestBody CreateExpenseRequest request) {

        ExpenseResponse response = expenseService.create(currentUserId(authentication), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ExpenseResponse> getById(
            Authentication authentication,
            @PathVariable Long id) {

        return ResponseEntity.ok(expenseService.getById(currentUserId(authentication), id));
    }

    @GetMapping
    public ResponseEntity<List<ExpenseResponse>> getAll(
            Authentication authentication,
            @RequestParam(required = false) LocalDate startDate,
            @RequestParam(required = false) LocalDate endDate,
            @RequestParam(required = false) Long categoryId) {

        Long userId = currentUserId(authentication);

        if (categoryId != null) {
            return ResponseEntity.ok(expenseService.getByCategory(userId, categoryId));
        }
        if (startDate != null && endDate != null) {
            return ResponseEntity.ok(expenseService.getByDateRange(userId, startDate, endDate));
        }
        return ResponseEntity.ok(expenseService.getAll(userId));
    }

    @GetMapping("/summary")
    public ResponseEntity<Map<String, BigDecimal>> getTotalForPeriod(
            Authentication authentication,
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate) {

        BigDecimal total = expenseService.getTotalForPeriod(
                currentUserId(authentication), startDate, endDate);

        return ResponseEntity.ok(Map.of("total", total));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ExpenseResponse> update(
            Authentication authentication,
            @PathVariable Long id,
            @Valid @RequestBody UpdateExpenseRequest request) {

        return ResponseEntity.ok(
                expenseService.update(currentUserId(authentication), id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            Authentication authentication,
            @PathVariable Long id) {

        expenseService.delete(currentUserId(authentication), id);
        return ResponseEntity.noContent().build();
    }
}
