# Mahfazti REST API

## Base URL

```text
http://localhost:8080
```

Protected endpoints require:

```http
Authorization: Bearer <JWT>
```

---

# Authentication

## Register

```http
POST /api/auth/register
Content-Type: application/json
```

## Login

```http
POST /api/auth/login
Content-Type: application/json
```

The login response contains:

```json
{
  "accessToken": "JWT_TOKEN",
  "tokenType": "Bearer",
  "userId": 1,
  "firstName": "Ayman",
  "lastName": "User",
  "email": "user@example.com",
  "role": "USER",
  "profileImageUrl": null
}
```

---

# Users

## Get Current User

```http
GET /api/users/me
Authorization: Bearer <JWT>
```

## Update Current User

```http
PUT /api/users/me
Authorization: Bearer <JWT>
```

---

# Categories

## Get Available Categories

```http
GET /api/categories
Authorization: Bearer <JWT>
```

Returns categories available to the authenticated user.

---

# Expenses

## Create Expense

```http
POST /api/expenses
Authorization: Bearer <JWT>
Content-Type: application/json
```

Example:

```json
{
  "amount": 25.50,
  "categoryId": 5,
  "date": "2026-09-02",
  "time": "10:30:00",
  "paymentMethod": "CASH",
  "description": "Lunch"
}
```

## Get Expenses

```http
GET /api/expenses
Authorization: Bearer <JWT>
```

## Get Expense

```http
GET /api/expenses/{id}
Authorization: Bearer <JWT>
```

## Expense Summary

```http
GET /api/expenses/summary?startDate=2026-09-01&endDate=2026-09-30
Authorization: Bearer <JWT>
```

## Update Expense

```http
PUT /api/expenses/{id}
Authorization: Bearer <JWT>
```

## Delete Expense

```http
DELETE /api/expenses/{id}
Authorization: Bearer <JWT>
```

### Payment Methods

```text
CASH
CREDIT_CARD
DEBIT_CARD
BANK_TRANSFER
DIGITAL_WALLET
OTHER
```

---

# Income

## Create Income

```http
POST /api/incomes
Authorization: Bearer <JWT>
```

## Get Income

```http
GET /api/incomes
Authorization: Bearer <JWT>
```

## Get Income By ID

```http
GET /api/incomes/{id}
Authorization: Bearer <JWT>
```

## Update Income

```http
PUT /api/incomes/{id}
Authorization: Bearer <JWT>
```

## Delete Income

```http
DELETE /api/incomes/{id}
Authorization: Bearer <JWT>
```

### Income Sources

```text
SALARY
FREELANCE
ALLOWANCE
GIFT
OTHER
```

---

# Budgets

## Create Budget

```http
POST /api/budgets
Authorization: Bearer <JWT>
Content-Type: application/json
```

Example:

```json
{
  "amount": 400.00,
  "categoryId": 5,
  "year": 2026,
  "month": 9
}
```

## Get All Budgets

```http
GET /api/budgets
Authorization: Bearer <JWT>
```

## Get Budgets By Month

```http
GET /api/budgets?year=2026&month=9
Authorization: Bearer <JWT>
```

## Get Budget

```http
GET /api/budgets/{id}
Authorization: Bearer <JWT>
```

## Update Budget

```http
PUT /api/budgets/{id}
Authorization: Bearer <JWT>
```

## Delete Budget

```http
DELETE /api/budgets/{id}
Authorization: Bearer <JWT>
```

## Duplicate Protection

The backend prevents multiple budgets for:

```text
same user
+
same category
+
same year
+
same month
```

---

# Reports

## Daily

```http
GET /api/reports/daily?date=2026-09-02
Authorization: Bearer <JWT>
```

## Weekly

```http
GET /api/reports/weekly?date=2026-09-02
Authorization: Bearer <JWT>
```

The date can be any date inside the target week.

## Monthly

```http
GET /api/reports/monthly?year=2026&month=9
Authorization: Bearer <JWT>
```

The monthly response includes budget usage when budgets exist.

## Yearly

```http
GET /api/reports/yearly?year=2026
Authorization: Bearer <JWT>
```

---

# Notifications

Notifications are generated internally by backend services.

## Get All

```http
GET /api/notifications
Authorization: Bearer <JWT>
```

## Get Unread

```http
GET /api/notifications/unread
Authorization: Bearer <JWT>
```

## Get Unread Count

```http
GET /api/notifications/unread-count
Authorization: Bearer <JWT>
```

## Mark One as Read

```http
PUT /api/notifications/{id}/read
Authorization: Bearer <JWT>
```

## Mark All as Read

```http
PUT /api/notifications/read-all
Authorization: Bearer <JWT>
```

## Delete

```http
DELETE /api/notifications/{id}
Authorization: Bearer <JWT>
```

### Notification Types

```text
BUDGET_WARNING
BUDGET_EXCEEDED
GOAL_PROGRESS
MONTHLY_REPORT
REMINDER
UNUSUAL_SPENDING
```

---

# Swagger

Interactive API documentation:

```text
http://localhost:8080/swagger-ui/index.html
```
