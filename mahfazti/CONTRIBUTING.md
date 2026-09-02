# Contributing to Mahfazti

Thank you for contributing to Mahfazti.

## 🌿 Git Workflow

The recommended branch structure is:

```text
main
  │
  └── develop
        │
        ├── feature/...
        ├── fix/...
        ├── refactor/...
        └── docs/...
```

## 1. Update Develop

```bash
git checkout develop
git pull origin develop
```

## 2. Create a Branch

Feature:

```bash
git checkout -b feature/feature-name
```

Bug fix:

```bash
git checkout -b fix/bug-name
```

Refactoring:

```bash
git checkout -b refactor/change-name
```

Documentation:

```bash
git checkout -b docs/documentation-name
```

## 3. Make Changes

Keep changes focused and follow the existing feature-based architecture.

## 4. Test

Backend:

```bash
./mvnw clean compile
./mvnw test
```

Flutter, when applicable:

```bash
flutter analyze
flutter test
```

## 5. Commit

Recommended commit format:

```text
feat: add budget management
fix: prevent duplicate monthly budgets
refactor: improve expense service
docs: update API documentation
test: add budget service tests
chore: update dependencies
```

## 6. Push

```bash
git push -u origin feature/feature-name
```

## 7. Pull Request

Create a Pull Request from your branch into `develop`.

A Pull Request should explain:

* What changed
* Why it changed
* How it was tested
* Whether the API changed
* Whether the database changed
* Whether there are breaking changes

## Code Guidelines

### Java

* Follow the existing feature-based package structure.
* Keep controllers focused on HTTP concerns.
* Keep business logic in services.
* Use repositories for persistence.
* Use DTOs for API contracts.
* Validate incoming requests.
* Validate ownership of user resources.
* Avoid exposing entities directly.

### Financial Data

Use `BigDecimal` for monetary values.

Do not use `double` or `float` for stored financial amounts.

### Security

Never commit:

```text
Passwords
JWT secrets
API keys
Private keys
Production credentials
```

## Pull Request Checklist

* [ ] Code compiles
* [ ] Tests pass
* [ ] No secrets committed
* [ ] Existing functionality still works
* [ ] API documentation updated if necessary
* [ ] Database changes reviewed
* [ ] Breaking changes documented
* [ ] Commit messages are meaningful
