# Contributing to Mahfazti

Thank you for contributing to Mahfazti.

The project follows a Clean Architecture structure, so changes should preserve separation of responsibilities.

---

## Development Guidelines

### 1. Follow the project architecture

Use the appropriate layer:

```text
presentation/
domain/
data/
core/
```

Do not place API calls directly inside screens.

---

### 2. API communication

API communication should go through:

```text
RemoteDataSource
    ↓
ApiClient
```

Do not use Dio directly inside UI widgets.

---

### 3. Repository pattern

The Domain layer defines repository contracts:

```text
domain/repositories/
```

The Data layer implements them:

```text
data/repositories/
```

---

### 4. Models and Entities

API JSON structures belong to:

```text
data/models/
```

Application/business entities belong to:

```text
domain/entities/
```

Do not mix API-specific JSON logic into domain entities.

---

### 5. Error handling

Use the centralized application exception system.

Errors should be converted through the shared error handling layer rather than manually creating different error messages inside every screen.

---

### 6. UI consistency

Use the shared theme:

```text
presentation/theme/
```

Use shared widgets when possible:

```text
presentation/widgets/
```

Loading, error, and empty states should remain visually consistent throughout the application.

---

## Naming Conventions

Use:

```text
snake_case.dart
```

For example:

```text
expense_repository.dart
expense_repository_impl.dart
add_expense_screen.dart
```

Classes use:

```text
PascalCase
```

For example:

```dart
class ExpenseRepositoryImpl {}
```

---

## Formatting

Run:

```bash
dart format lib
```

before committing.

---

## Static Analysis

Run:

```bash
flutter analyze
```

All introduced errors should be resolved before opening a Pull Request.

---

## Commit Messages

Use clear and descriptive commit messages.

Examples:

```text
feat: add expense management screens
fix: handle expired JWT token
refactor: improve repository structure
style: update dashboard theme
docs: update README
```

---

## Pull Requests

A Pull Request should:

* Have a clear title
* Explain what was changed
* Mention important implementation details
* Include screenshots for major UI changes
* Pass `flutter analyze`
* Avoid unrelated changes

---

## Branching

Recommended branches:

```text
main
develop
feature/*
fix/*
refactor/*
docs/*
```

Examples:

```text
feature/expense-management
feature/auth-flow
fix/notification-error
refactor/repository-layer
```
