package com.ayman.mahfazti.user.dto;

import jakarta.validation.constraints.Size;

public record UpdateUserRequest(

        @Size(max = 50)
        String firstName,

        @Size(max = 50)
        String lastName,

        @Size(max = 20)
        String phone,

        @Size(max = 500)
        String profileImageUrl

) {
}