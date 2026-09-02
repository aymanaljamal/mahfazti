# 💰 Mahfazti Mobile

**Mahfazti (محفظتي)** is a modern personal finance mobile application built with Flutter and a Java Spring Boot backend.

The application helps users manage their income, expenses, budgets, categories, notifications, and financial reports through a clean and user-friendly Arabic interface.

---

## ✨ Features

### Authentication

* User registration
* User login
* JWT-based authentication
* Secure access token storage
* Logout and local session management

### Personal Finance

* Add income
* Edit income
* Delete income
* Filter income by date
* Add expenses
* Edit expenses
* Delete expenses
* Filter expenses by date and category
* Expense summary
* Payment method support

### Budget Management

* Create budgets
* Update budgets
* Delete budgets
* Filter budgets by year and month
* Category-based budgets

### Reports

* Daily financial report
* Weekly financial report
* Monthly financial report
* Yearly financial report
* Category spending breakdown
* Spending comparisons
* Budget usage percentage

### Notifications

* View notifications
* View unread notifications
* Unread notification count
* Mark notification as read
* Mark all notifications as read
* Delete notifications

### Profile

* View current user
* Update personal information
* Profile image URL support

---

## 🏗️ Architecture

The Flutter application follows a layered **Clean Architecture** approach.

```text
lib/
├── app/
│   ├── app.dart
│   └── router.dart
│
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── network/
│   │   └── api_client.dart
│   ├── storage/
│   │   └── secure_storage.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── error_handler.dart
│   └── utils/
│       └── validators.dart
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

### Layers

**Presentation**

* Screens
* Providers
* Shared widgets
* Theme

**Domain**

* Entities
* Enums
* Repository contracts
* Use cases

**Data**

* Remote data sources
* API models
* Repository implementations

**Core**

* API configuration
* Networking
* Secure storage
* Error handling
* Validation

---

## 🛠️ Technologies

### Mobile Application

* Flutter
* Dart
* Riverpod
* Dio
* GoRouter
* Flutter Secure Storage
* Intl
* FL Chart

### Backend

* Java
* Spring Boot
* Spring Security
* JWT
* Spring Data JPA
* Hibernate
* MySQL

---

## 🌐 Backend API

The mobile application communicates with the Spring Boot backend.

### Android Emulator

```text
http://10.0.2.2:8080
```

### API Endpoints

```text
POST   /api/auth/login
POST   /api/auth/register

GET    /api/users/me
PUT    /api/users/me

GET    /api/categories

GET    /api/expenses
GET    /api/expenses/{id}
POST   /api/expenses
PUT    /api/expenses/{id}
DELETE /api/expenses/{id}
GET    /api/expenses/summary

GET    /api/incomes
GET    /api/incomes/{id}
POST   /api/incomes
PUT    /api/incomes/{id}
DELETE /api/incomes/{id}

GET    /api/budgets
GET    /api/budgets/{id}
POST   /api/budgets
PUT    /api/budgets/{id}
DELETE /api/budgets/{id}

GET    /api/notifications
GET    /api/notifications/unread
GET    /api/notifications/unread-count
PUT    /api/notifications/{id}/read
PUT    /api/notifications/read-all
DELETE /api/notifications/{id}

GET    /api/reports/daily
GET    /api/reports/weekly
GET    /api/reports/monthly
GET    /api/reports/yearly
```

---

## 📱 Application Screens

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

## 🔐 Authentication

Mahfazti uses JWT authentication.

After successful login or registration:

```text
Backend
   ↓
Access Token
   ↓
SecureStorage
   ↓
Authorization: Bearer <token>
```

The access token is automatically attached to authenticated API requests.

---

## 🎨 UI & UX

The application is designed for Arabic-speaking users and follows an RTL-friendly interface.

The shared theme provides:

* Centralized colors
* Centralized text styles
* Shared buttons
* Shared input styling
* Shared cards
* Consistent error states
* Consistent loading states
* Consistent empty states
* Responsive layouts

---

## 🚀 Getting Started

### 1. Clone the project

```bash
git clone <repository-url>
cd mahfazti_mobile
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Make sure the backend is running

The backend should be available on:

```text
http://localhost:8080
```

For the Android emulator, the Flutter application uses:

```text
http://10.0.2.2:8080
```

### 4. Run the application

```bash
flutter run
```

---

## 🧪 Code Quality

Before committing changes, run:

```bash
flutter analyze
```

You can also format the project with:

```bash
dart format lib
```

---

## 📂 Project Structure

The project is organized to keep responsibilities separated:

```text
Presentation
     ↓
Domain
     ↓
Data
     ↓
API / Backend
```

The UI never communicates directly with Dio or JSON models.

---

## 🔒 Security

Sensitive authentication data is stored using:

```text
flutter_secure_storage
```

JWT tokens are not stored in regular application preferences.

---

## 📌 Development Status

The project is under active development.

Current completed foundation:

* Core networking ✅
* Secure token storage ✅
* Error handling ✅
* Validation ✅
* API constants ✅
* Domain entities ✅
* Domain enums ✅
* Data models ✅
* Remote data sources ✅
* Repository contracts ✅
* Repository implementations ✅
* Application theme ✅
* Application routing foundation ✅

---

## 👨‍💻 Developer

**Ayman Al-Jamal**

Computer Science Graduate
Backend & Mobile Application Development

---

## 📄 License

This project is currently intended for educational and development purposes.
