package com.ayman.mahfazti.category.dto;

public record CategoryResponse(
        Long id,
        String name,
        String icon,
        String color,
        boolean isDefault
) {
}