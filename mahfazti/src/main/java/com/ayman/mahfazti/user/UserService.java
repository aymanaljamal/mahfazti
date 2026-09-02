package com.ayman.mahfazti.user;

import com.ayman.mahfazti.user.dto.UpdateUserRequest;
import com.ayman.mahfazti.user.dto.UserResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserResponse getCurrentUser(String email) {

        User user = userRepository
                .findByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found")
                );

        return userMapper.toResponse(user);
    }

    public UserResponse updateCurrentUser(
            String email,
            UpdateUserRequest request
    ) {

        User user = userRepository
                .findByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found")
                );

        if (request.firstName() != null &&
                !request.firstName().isBlank()) {
            user.setFirstName(request.firstName().trim());
        }

        if (request.lastName() != null &&
                !request.lastName().isBlank()) {
            user.setLastName(request.lastName().trim());
        }

        if (request.phone() != null) {
            user.setPhone(request.phone());
        }

        if (request.profileImageUrl() != null) {
            user.setProfileImageUrl(request.profileImageUrl());
        }

        User updatedUser = userRepository.save(user);

        return userMapper.toResponse(updatedUser);
    }
}