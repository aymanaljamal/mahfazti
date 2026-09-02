package com.ayman.mahfazti.category;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    @Query("SELECT c FROM Category c WHERE c.isDefault = true OR c.user.id = :userId")
    List<Category> findAllAvailableForUser(@Param("userId") Long userId);

    boolean existsByIdAndUserId(Long id, Long userId);
}
