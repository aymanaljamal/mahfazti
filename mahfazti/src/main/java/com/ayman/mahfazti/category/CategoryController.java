package com.ayman.mahfazti.category;

import com.ayman.mahfazti.category.dto.CategoryResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public List<CategoryResponse> getCategories(
            Authentication authentication
    ) {
        return categoryService.getAvailableCategories(
                authentication.getName()
        );
    }
}