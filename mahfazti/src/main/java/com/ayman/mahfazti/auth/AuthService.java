package com.ayman.mahfazti.auth;
import com.ayman.mahfazti.auth.dto.*;
import com.ayman.mahfazti.common.enums.Role;
import com.ayman.mahfazti.security.JwtService;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;

    public AuthResponse register(RegisterRequest request) {

        String email = request.email().toLowerCase().trim();

        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException(
                    "Email is already registered"
            );
        }

        User user = User.builder()
                .firstName(request.firstName().trim())
                .lastName(request.lastName().trim())
                .email(email)
                .password(
                        passwordEncoder.encode(
                                request.password()
                        )
                )
                .phone(request.phone())
                .role(Role.USER)
                .enabled(true)
                .build();

        User savedUser =
                userRepository.save(user);

        UserDetails userDetails =
                createUserDetails(savedUser);

        String token =
                jwtService.generateToken(userDetails);

        return buildResponse(
                savedUser,
                token
        );
    }

    public AuthResponse login(LoginRequest request) {

        String email =
                request.email().toLowerCase().trim();

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        email,
                        request.password()
                )
        );

        User user =
                userRepository
                        .findByEmail(email)
                        .orElseThrow();

        String token =
                jwtService.generateToken(
                        createUserDetails(user)
                );

        return buildResponse(
                user,
                token
        );
    }

    private UserDetails createUserDetails(User user) {

        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                user.isEnabled(),
                true,
                true,
                true,
                List.of(
                        new org.springframework.security.core.authority.SimpleGrantedAuthority(
                                "ROLE_" + user.getRole().name()
                        )
                )
        );
    }

    private AuthResponse buildResponse(
            User user,
            String token
    ) {

        return new AuthResponse(
                token,
                "Bearer",
                user.getId(),
                user.getFirstName(),
                user.getLastName(),
                user.getEmail(),
                user.getRole().name(),
                user.getProfileImageUrl()
        );
    }
}