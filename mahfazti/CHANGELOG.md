# Changelog

All notable changes to Mahfazti are documented in this file.

The format is based on Keep a Changelog.

---

## [Unreleased]

### Planned

* Financial goals
* Goal progress tracking
* Goal notifications
* Spending insights
* Unusual spending detection
* Receipt OCR
* Automatic expense categorization
* Recurring expenses
* Multi-currency support
* PDF and Excel export
* Cloud synchronization
* Bank account integration
* Shared household budgets

---

## [0.1.0] - 2026-09-02

### Added

* Spring Boot backend foundation
* MySQL database integration
* JPA/Hibernate persistence
* User registration
* User login
* JWT authentication
* BCrypt password encryption
* User profile management
* Category management
* Default financial categories
* Expense CRUD operations
* Income CRUD operations
* Budget CRUD operations
* Monthly category-based budgets
* Duplicate budget protection
* Budget usage calculation
* 80% budget warning notification
* 100% budget exceeded notification
* Notification management
* Daily financial reports
* Weekly financial reports
* Monthly financial reports
* Yearly financial reports
* Category spending breakdown
* Previous-period comparisons
* Swagger/OpenAPI documentation
* Global exception handling
* Request validation
* User ownership protection
* CORS configuration

### Changed

* Integrated budget usage into monthly reports.
* Added budget validation to expense creation/update workflows.
* Improved category access validation for expenses.
* Improved duplicate budget handling.

### Testing

The backend was manually tested through Postman for:

* Authentication
* Expense creation
* Expense update
* Expense category update
* Budget creation
* Budget update
* Duplicate budget rejection
* Budget warning notification
* Budget exceeded notification
* Financial reports
* Notification retrieval
