package com.ayman.mahfazti.config;

import com.ayman.mahfazti.category.Category;
import com.ayman.mahfazti.category.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;

    @Override
    public void run(String... args) {

        // Add default categories only if none exist
        if (categoryRepository.count() > 0) {
            return;
        }

        List<Category> categories = List.of(

                createCategory(
                        "Food",
                        "restaurant",
                        "#FF9800"
                ),

                createCategory(
                        "Transportation",
                        "directions_car",
                        "#2196F3"
                ),

                createCategory(
                        "Housing",
                        "home",
                        "#795548"
                ),

                createCategory(
                        "Shopping",
                        "shopping_cart",
                        "#E91E63"
                ),

                createCategory(
                        "Health",
                        "favorite",
                        "#F44336"
                ),

                createCategory(
                        "Education",
                        "school",
                        "#9C27B0"
                ),

                createCategory(
                        "Entertainment",
                        "sports_esports",
                        "#673AB7"
                ),

                createCategory(
                        "Bills",
                        "receipt",
                        "#607D8B"
                ),

                createCategory(
                        "Clothing",
                        "checkroom",
                        "#009688"
                ),

                createCategory(
                        "Subscriptions",
                        "subscriptions",
                        "#3F51B5"
                ),

                createCategory(
                        "Other",
                        "category",
                        "#757575"
                )
        );

        categoryRepository.saveAll(categories);

        System.out.println(
                "Default categories initialized successfully."
        );
    }

    private Category createCategory(
            String name,
            String icon,
            String color
    ) {
        return Category.builder()
                .name(name)
                .icon(icon)
                .color(color)
                .isDefault(true)
                .user(null)
                .build();
    }
}