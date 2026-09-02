# 💰 Mahfazti — محفظتي

**Mahfazti (محفظتي)** is a personal finance management system designed to help users manage their income, expenses, budgets, categories, notifications, and financial reports through a modern mobile application connected to a secure REST API backend.

The project is divided into two main applications:

```text
Mahfazti
├── Backend      → Java + Spring Boot
└── Mobile App   → Flutter + Dart
```

---

## 📌 Project Overview

Mahfazti is designed as a full-stack personal finance management solution.

The system allows users to:

- Create an account and log in securely
- Manage personal information
- Record income
- Record and manage expenses
- Organize expenses using categories
- Create monthly budgets
- Track financial activity
- View daily, weekly, monthly, and yearly reports
- Receive and manage financial notifications
- Monitor remaining balance and spending behavior

The mobile application communicates with the backend through RESTful APIs secured using JWT authentication.

---

# 🏗️ Project Structure

```text
mahfazti/
│
├── README.md
│
├── mahfazti/
│   └── Backend
│
└── mahfazti_mobile/
    └── Flutter Mobile Application
```

---

# 🔵 1. Mahfazti Backend

The backend is responsible for business logic, authentication, database management, financial calculations, and REST API services.

## Technologies

- Java
- Spring Boot
- Spring Security
- JWT
- Spring Data JPA
- Hibernate
- MySQL
- MapStruct
- Springdoc OpenAPI / Swagger

## Backend Responsibilities

The backend provides APIs for:

### Authentication

```text
POST /api/auth/login
POST /api/auth/register
```

### User

```text
GET /api/users/me
PUT /api/users/me
```

### Categories

```text
GET /api/categories
```

### Expenses

```text
GET    /api/expenses
GET    /api/expenses/{id}
POST   /api/expenses
PUT    /api/expenses/{id}
DELETE /api/expenses/{id}

GET /api/expenses/summary
```

### Income

```text
GET    /api/incomes
GET    /api/incomes/{id}
POST   /api/incomes
PUT    /api/incomes/{id}
DELETE /api/incomes/{id}
```

### Budgets

```text
GET    /api/budgets
GET    /api/budgets/{id}
POST   /api/budgets
PUT    /api/budgets/{id}
DELETE /api/budgets/{id}
```

### Notifications

```text
GET    /api/notifications
GET    /api/notifications/unread
GET    /api/notifications/unread-count
PUT    /api/notifications/{id}/read
PUT    /api/notifications/read-all
DELETE /api/notifications/{id}
```

### Reports

```text
GET /api/reports/daily
GET /api/reports/weekly
GET /api/reports/monthly
GET /api/reports/yearly
```

---

# 🟢 2. Mahfazti Mobile

The mobile application is built using Flutter and provides the user interface for interacting with the Mahfazti backend.

## Technologies

- Flutter
- Dart
- Riverpod
- Dio
- GoRouter
- Flutter Secure Storage
- Intl
- FL Chart

---

## 📱 Mobile Architecture

The mobile application follows a layered Clean Architecture approach.

```text
lib/
├── app/
│   ├── app.dart
│   └── router.dart
│
├── core/
│   ├── constants/
│   ├── network/
│   ├── storage/
│   ├── errors/
│   └── utils/
│
├── data/
│   ├── datasources/
│   │   └── remote/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── enums/
│   ├── repositories/
│   └── usecases/
│
├── presentation/
│   ├── providers/
│   ├── screens/
│   ├── theme/
│   └── widgets/
│
└── main.dart
```

---

# 🔐 Authentication Flow

Mahfazti uses JWT-based authentication.

```text
Flutter
   │
   │ Login / Register
   ▼
Spring Boot API
   │
   │ Access Token
   ▼
Flutter Secure Storage
   │
   │ Bearer Token
   ▼
Authenticated API Requests
```

The token is automatically added to authenticated requests through the shared API client.

Logout is currently handled locally by removing the stored access token because the backend does not expose a logout endpoint.

---

# 🔄 Communication Between Projects

The two applications communicate through HTTP REST APIs.

```text
┌─────────────────────────┐
│   Mahfazti Mobile       │
│   Flutter / Dart        │
└────────────┬────────────┘
             │
             │ HTTP / JSON
             │ JWT
             ▼
┌─────────────────────────┐
│   Mahfazti Backend      │
│   Spring Boot / Java    │
└────────────┬────────────┘
             │
             │ JPA / Hibernate
             ▼
┌─────────────────────────┐
│        MySQL            │
└─────────────────────────┘
```

---

# 📱 Mobile Screens

The mobile application contains the following main routes:

```text
/login
/register
/

/expenses
/expenses/add
/expenses/edit/:id

/income
/income/add
/income/edit/:id

/budgets
/budgets/add
/budgets/edit/:id

/reports
/notifications
/profile
```

---

# 💸 Financial Management

## Expenses

Users can:

- Add expenses
- Edit expenses
- Delete expenses
- Filter expenses by date
- Filter expenses by category
- Select payment methods
- View expense summaries

Supported payment methods:

```text
CASH
CREDIT_CARD
DEBIT_CARD
BANK_TRANSFER
DIGITAL_WALLET
OTHER
```

## Income

Users can:

- Add income
- Edit income
- Delete income
- Filter income by date

Supported income sources:

```text
SALARY
FREELANCE
ALLOWANCE
GIFT
OTHER
```

## Budgets

Users can:

- Create budgets
- Update budgets
- Delete budgets
- Filter budgets by year and month
- Track budget usage by category

---

# 📊 Financial Reports

Mahfazti provides:

### Daily Report

Includes:

- Total income
- Total expenses
- Transaction count
- Highest expense
- Category breakdown

### Weekly Report

Includes:

- Weekly expenses
- Average daily spending
- Highest spending day
- Most expensive category
- Previous week comparison
- Percentage change

### Monthly Report

Includes:

- Total income
- Total expenses
- Remaining balance
- Average daily spending
- Category breakdown
- Previous month comparison
- Budget usage percentage

### Yearly Report

Includes:

- Total annual income
- Total annual expenses
- Monthly income breakdown
- Monthly expense breakdown

---

# 🔔 Notifications

The backend supports financial notifications such as:

```text
BUDGET_WARNING
BUDGET_EXCEEDED
GOAL_PROGRESS
REMINDER
MONTHLY_REPORT
UNUSUAL_SPENDING
```

Users can:

- View all notifications
- View unread notifications
- View unread count
- Mark one notification as read
- Mark all notifications as read
- Delete notifications

---

# 🎨 User Interface

The mobile application is designed primarily for Arabic-speaking users.

The application follows:

- RTL layout
- Centralized theme
- Centralized colors
- Centralized typography
- Responsive layouts
- Shared loading states
- Shared error states
- Shared empty states
- Consistent buttons and input fields
- Consistent navigation

---

# 🌐 Development Environment

## Backend

Default backend address:

```text
http://localhost:8080
```

## Android Emulator

For the Flutter Android Emulator:

```text
http://10.0.2.2:8080
```

The mobile application's API base URL is configured in:

```text
mahfazti_mobile/lib/core/constants/api_constants.dart
```

---

# 🚀 Running the Backend

Navigate to the backend project:

```powershell
cd mahfazti
```

Then start the Spring Boot application according to the backend's Maven configuration.

The API should be available at:

```text
http://localhost:8080
```

Swagger documentation is available through the Springdoc configuration when the backend is running.

---

# 🚀 Running the Mobile Application

Navigate to the Flutter project:

```powershell
cd mahfazti_mobile
```

Install dependencies:

```powershell
flutter pub get
```

Run the application:

```powershell
flutter run
```

---

# 🧪 Code Quality

Before committing Flutter changes:

```powershell
flutter analyze
```

Format the code:

```powershell
dart format lib
```

---

# 🌿 Git Workflow

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
feature/authentication
feature/expense-management
feature/reports
fix/api-error
refactor/repository-layer
```

---

# 📂 Repository Organization

The root repository contains both applications:

```text
mahfazti/
│
├── README.md
│
├── mahfazti/
│   ├── src/
│   ├── pom.xml
│   └── ...
│
└── mahfazti_mobile/
    ├── lib/
    ├── android/
    ├── ios/
    ├── pubspec.yaml
    └── ...
```

---

# 🔒 Security

The system uses:

- JWT authentication
- Spring Security
- Secure password hashing on the backend
- Secure token storage on mobile
- Authorization headers for authenticated requests
- Environment-based configuration for sensitive settings

Sensitive configuration files and credentials should never be committed to Git.

---

# 📌 Development Status

The project foundation includes:

```text
Backend
✅ Authentication
✅ JWT Security
✅ User Management
✅ Categories
✅ Expenses
✅ Income
✅ Budgets
✅ Notifications
✅ Reports
✅ MySQL Integration
✅ Swagger API Documentation

Mobile
✅ Clean Architecture Foundation
✅ API Client
✅ Secure Storage
✅ Error Handling
✅ Validation
✅ Domain Entities
✅ Domain Enums
✅ Data Models
✅ Remote Data Sources
✅ Repository Layer
✅ Theme
✅ Routing Foundation
✅ Dashboard Foundation
```

The remaining UI and application state-management features are being developed incrementally.

---

# 👨‍💻 Developer

**Ayman Al-Jamal**

Computer Science Graduate

Full-Stack Development  
Backend Engineering  
Flutter Mobile Development

---

# 📄 License

The project is currently intended for educational and development purposes.