package com.ayman.mahfazti.income;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.income.dto.CreateIncomeRequest;
import com.ayman.mahfazti.income.dto.IncomeResponse;
import com.ayman.mahfazti.income.dto.UpdateIncomeRequest;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class IncomeService {

    private final IncomeRepository incomeRepository;
    private final UserRepository userRepository;

    public IncomeResponse createIncome(
            String email,
            CreateIncomeRequest request) {

        User user = getUserByEmail(email);

        Income income = Income.builder()
                .user(user)
                .amount(request.amount())
                .source(request.source())
                .date(request.date())
                .description(request.description())
                .build();

        return toResponse(incomeRepository.save(income));
    }

    @Transactional(readOnly = true)
    public List<IncomeResponse> getAllIncomes(String email) {

        User user = getUserByEmail(email);

        return incomeRepository
                .findByUserIdOrderByDateDesc(user.getId())
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<IncomeResponse> getIncomesByDateRange(
            String email,
            LocalDate startDate,
            LocalDate endDate) {

        User user = getUserByEmail(email);

        return incomeRepository
                .findByUserIdAndDateBetweenOrderByDateDesc(
                        user.getId(),
                        startDate,
                        endDate)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public IncomeResponse getIncomeById(
            String email,
            Long id) {

        User user = getUserByEmail(email);

        Income income = incomeRepository
                .findByIdAndUserId(id, user.getId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Income not found"));

        return toResponse(income);
    }

    public IncomeResponse updateIncome(
            String email,
            Long id,
            UpdateIncomeRequest request) {

        User user = getUserByEmail(email);

        Income income = incomeRepository
                .findByIdAndUserId(id, user.getId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Income not found"));

        income.setAmount(request.amount());
        income.setSource(request.source());
        income.setDate(request.date());
        income.setDescription(request.description());

        return toResponse(incomeRepository.save(income));
    }

    public void deleteIncome(
            String email,
            Long id) {

        User user = getUserByEmail(email);

        Income income = incomeRepository
                .findByIdAndUserId(id, user.getId())
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Income not found"));

        incomeRepository.delete(income);
    }

    private User getUserByEmail(String email) {

        return userRepository.findByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "User not found"));
    }

    private IncomeResponse toResponse(Income income) {

        return new IncomeResponse(
                income.getId(),
                income.getAmount(),
                income.getSource(),
                income.getDate(),
                income.getDescription(),
                income.getCreatedAt(),
                income.getUpdatedAt()
        );
    }
}

