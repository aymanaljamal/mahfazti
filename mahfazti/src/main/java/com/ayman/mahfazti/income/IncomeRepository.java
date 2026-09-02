package com.ayman.mahfazti.income;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface IncomeRepository extends JpaRepository<Income, Long> {

    Optional<Income> findByIdAndUserId(Long id, Long userId);

    List<Income> findByUserIdOrderByDateDesc(Long userId);

    List<Income> findByUserIdAndDateBetweenOrderByDateDesc(
            Long userId, LocalDate startDate, LocalDate endDate);

    @Query("SELECT COALESCE(SUM(i.amount), 0) FROM Income i " +
            "WHERE i.user.id = :userId AND i.date BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByUserIdAndDateBetween(
            @Param("userId") Long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);
}
