package com.ayman.mahfazti.expense;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    Optional<Expense> findByIdAndUserId(Long id, Long userId);

    List<Expense> findByUserIdOrderByDateDescTimeDesc(Long userId);

    List<Expense> findByUserIdAndDateBetweenOrderByDateDescTimeDesc(
            Long userId, LocalDate startDate, LocalDate endDate);

    List<Expense> findByUserIdAndCategoryId(Long userId, Long categoryId);

    @Query("SELECT COALESCE(SUM(e.amount), 0) FROM Expense e "
            + "WHERE e.user.id = :userId AND e.date BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByUserIdAndDateBetween(
            @Param("userId") Long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    long countByUserIdAndDateBetween(Long userId, LocalDate startDate, LocalDate endDate);

    List<Expense> findByUserIdAndDateOrderByAmountDesc(Long userId, LocalDate date);

    @Query("SELECT e.category.id, e.category.name, e.category.icon, SUM(e.amount) "
            + "FROM Expense e WHERE e.user.id = :userId AND e.date BETWEEN :startDate AND :endDate "
            + "GROUP BY e.category.id, e.category.name, e.category.icon "
            + "ORDER BY SUM(e.amount) DESC")
    List<Object[]> sumAmountGroupByCategory(
            @Param("userId") Long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    @Query("""
    SELECT COALESCE(SUM(e.amount), 0)
    FROM Expense e
    WHERE e.user.id = :userId
      AND e.category.id = :categoryId
      AND e.date BETWEEN :startDate AND :endDate
""")
    BigDecimal sumAmountByUserIdAndCategoryIdAndDateBetween(
            @Param("userId") Long userId,
            @Param("categoryId") Long categoryId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);
}
