package com.ayman.mahfazti.user;

import com.ayman.mahfazti.user.dto.UpdateUserRequest;
import com.ayman.mahfazti.user.dto.UserResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public UserResponse getCurrentUser(
            Authentication authentication
    ) {

        return userService.getCurrentUser(
                authentication.getName()
        );
    }

    @PutMapping("/me")
    public UserResponse updateCurrentUser(
            Authentication authentication,
            @Valid @RequestBody UpdateUserRequest request
    ) {

        return userService.updateCurrentUser(
                authentication.getName(),
                request
        );
    }
}