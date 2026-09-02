# Mahfazti Architecture

## Overview

Mahfazti uses a client-server architecture.

```text
Flutter Mobile Application
          │
          │ REST API + JWT
          ▼
Spring Boot Backend
          │
          ├── Controllers
          ├── Services
          ├── Repositories
          ├── DTOs
          ├── Mappers
          ├── Security
          └── Exception Handling
          │
          ▼
        MySQL
```

---

# Backend Architecture

The backend follows a feature-based architecture.

Each major domain contains its own:

* Entity
* Repository
* Service
* Controller
* DTOs
* Mapper where required

This keeps related business logic together.

---

# Request Flow

Typical request:

```text
Flutter
   │
   ▼
REST Controller
   │
   ▼
Service
   │
   ▼
Repository
   │
   ▼
MySQL
```

Response:

```text
MySQL
   │
   ▼
Repository
   │
   ▼
Service
   │
   ▼
DTO / Mapper
   │
   ▼
REST Controller
   │
   ▼
Flutter
```

---

# Authentication Flow

```text
Login
  │
  ▼
AuthController
  │
  ▼
AuthService
  │
  ▼
UserRepository
  │
  ▼
Password Verification
  │
  ▼
JwtService
  │
  ▼
JWT Token
```

For protected requests:

```text
Flutter
  │
  │ Authorization: Bearer JWT
  ▼
JwtAuthenticationFilter
  │
  ▼
JWT Validation
  │
  ▼
Authenticated User
  │
  ▼
Controller
```

---

# Expense and Budget Flow

When a user creates an expense:

```text
POST /api/expenses
        │
        ▼
ExpenseController
        │
        ▼
ExpenseService
        │
        ├── Validate User
        ├── Validate Category
        ├── Create Expense
        ├── Save Expense
        │
        ▼
BudgetService
        │
        ├── Find Monthly Budget
        ├── Calculate Previous Spending
        ├── Calculate Current Spending
        ├── Check 80%
        └── Check 100%
                 │
                 ▼
        NotificationService
```

---

# Budget Thresholds

```text
< 80%
   │
   └── Normal

>= 80%
   │
   └── BUDGET_WARNING

>= 100%
   │
   └── BUDGET_EXCEEDED
```

Notifications are generated when spending crosses the threshold.

---

# Reports

Reports are calculated live.

```text
Expenses
    +
Income
    +
Budgets
    │
    ▼
ReportService
    │
    ├── Daily
    ├── Weekly
    ├── Monthly
    └── Yearly
```

No duplicated report tables are required.

---

# Data Isolation

User-owned resources are always queried with the authenticated user's identity.

Examples:

```text
findByIdAndUserId(...)
findByUserId(...)
findByUserIdAndCategoryId(...)
```

This prevents one user from accessing another user's financial data.

---

# Monetary Values

Financial amounts are represented using:

```java
BigDecimal
```

This avoids the precision problems associated with floating-point monetary calculations.

---

# Database

Current development database:

```text
MySQL
```

Main domains:

```text
Users
Expenses
Income
Categories
Budgets
Notifications
```

Future domains include:

```text
Financial Goals
```
