package com.ayman.mahfazti.user.dto;

public record UserResponse(
        Long id,
        String firstName,
        String lastName,
        String email,
        String phone,
        String profileImageUrl,
        String role
) {
}