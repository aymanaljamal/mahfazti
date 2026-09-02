package com.ayman.mahfazti.category;

import com.ayman.mahfazti.category.dto.CategoryResponse;
import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    public List<CategoryResponse> getAvailableCategories(String email) {

        User user = userRepository
                .findByEmail(email)
                .orElseThrow(() ->
                        new ResourceNotFoundException("User not found")
                );

        return categoryRepository
                .findAllAvailableForUser(user.getId())
                .stream()
                .map(category -> new CategoryResponse(
                        category.getId(),
                        category.getName(),
                        category.getIcon(),
                        category.getColor(),
                        category.isDefault()
                ))
                .toList();
    }
}