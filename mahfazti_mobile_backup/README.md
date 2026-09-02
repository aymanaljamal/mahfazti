أكيد. عدّلت الملفين بحيث يعكسوا **الحالة الفعلية الحالية للمشروع**: شاشات الدخل والمصروفات والميزانيات والتقارير والإشعارات والملف الشخصي موجودة، وكذلك الـ repositories والـ remote data sources والـ routing والـ Riverpod. وشلت العبارات التي أصبحت قديمة مثل أن الشاشات كلها ما زالت "In Progress".

### `README.md`

````markdown
# 💰 Mahfazti Mobile

**Mahfazti (محفظتي)** is a modern personal finance mobile application built with Flutter and a Java Spring Boot backend.

The application helps users manage their income, expenses, budgets, categories, notifications, and financial reports through a clean, responsive, and user-friendly Arabic interface.

---

## ✨ Features

### 🔐 Authentication

- User registration
- User login
- JWT-based authentication
- Secure access token storage
- Local session management
- Logout support

### 💰 Personal Finance

- Add income
- Edit income
- Delete income
- Filter income by date
- Add expenses
- Edit expenses
- Delete expenses
- Filter expenses by date
- Filter expenses by category
- Expense summary
- Multiple payment methods
- Multiple income sources

### 📊 Budget Management

- Create budgets
- Update budgets
- Delete budgets
- Filter budgets by year
- Filter budgets by month
- Category-based budgets
- Budget usage tracking

### 📈 Financial Reports

- Daily financial report
- Weekly financial report
- Monthly financial report
- Yearly financial report
- Category spending breakdown
- Spending comparisons
- Average daily spending
- Highest spending day
- Budget usage percentage
- Previous period comparisons

### 🔔 Notifications

- View all notifications
- View unread notifications
- Unread notification count
- Mark notification as read
- Mark all notifications as read
- Delete notifications
- Budget warning notifications
- Budget exceeded notifications
- Goal progress notifications
- Reminder notifications
- Monthly report notifications
- Unusual spending notifications

### 👤 Profile

- View current user
- Update personal information
- Update phone number
- Profile image URL support
- Display user role
- Logout

### 🗂️ Categories

- Load available categories
- Category-based expenses
- Category-based budgets
- Category names and icons

---

## 🏗️ Architecture

The Flutter application follows a layered architecture inspired by **Clean Architecture** principles.

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
````

### Layers

#### Presentation

* Screens
* Riverpod providers
* Shared widgets
* Theme
* UI state handling

#### Domain

* Entities
* Enums
* Repository contracts
* Business-level abstractions

#### Data

* Remote data sources
* API models
* Repository implementations
* Backend API communication

#### Core

* API configuration
* Dio networking
* Secure storage
* Error handling
* Validation utilities

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
* Lucide Icons

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

The mobile application communicates with the Spring Boot REST API.

### Android Emulator

```text
http://10.0.2.2:8080
```

### Web Browser

```text
http://localhost:8080
```

### API Endpoints

#### Authentication

```text
POST   /api/auth/login
POST   /api/auth/register
```

#### User

```text
GET    /api/users/me
PUT    /api/users/me
```

#### Categories

```text
GET    /api/categories
```

#### Expenses

```text
GET    /api/expenses
GET    /api/expenses/{id}
POST   /api/expenses
PUT    /api/expenses/{id}
DELETE /api/expenses/{id}
GET    /api/expenses/summary
```

#### Income

```text
GET    /api/incomes
GET    /api/incomes/{id}
POST   /api/incomes
PUT    /api/incomes/{id}
DELETE /api/incomes/{id}
```

#### Budgets

```text
GET    /api/budgets
GET    /api/budgets/{id}
POST   /api/budgets
PUT    /api/budgets/{id}
DELETE /api/budgets/{id}
```

#### Notifications

```text
GET    /api/notifications
GET    /api/notifications/unread
GET    /api/notifications/unread-count
PUT    /api/notifications/{id}/read
PUT    /api/notifications/read-all
DELETE /api/notifications/{id}
```

#### Reports

```text
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

## 🔑 Authentication Flow

Mahfazti uses JWT authentication.

After successful login or registration:

```text
Flutter
   │
   ▼
POST /api/auth/login
   │
   ▼
Spring Boot Backend
   │
   ▼
Access Token
   │
   ▼
Flutter Secure Storage
   │
   ▼
Authorization: Bearer <token>
```

The API client automatically attaches the access token to authenticated requests.

---

## 🎨 UI & UX

The application is designed primarily for Arabic-speaking users.

### UI characteristics

* Arabic interface
* RTL-friendly layout
* Responsive layouts
* Material 3 design
* Centralized color system
* Centralized typography
* Shared input styling
* Shared button styling
* Shared card styling
* Consistent loading states
* Consistent error states
* Consistent empty states
* Responsive dashboard
* Reusable presentation components

---

## 📁 Main Screens

### Dashboard

Provides an overview of the user's financial activity, including:

* Current financial summary
* Monthly income
* Monthly expenses
* Remaining balance
* Budget information
* Notifications
* Quick navigation to main sections

### Expenses

Allows users to:

* View expenses
* Add expenses
* Edit expenses
* Delete expenses
* Filter by date
* Filter by category
* Select payment methods

### Income

Allows users to:

* View income records
* Add income
* Edit income
* Delete income
* Filter by date
* Select income sources

### Budgets

Allows users to:

* View budgets
* Add budgets
* Edit budgets
* Delete budgets
* Filter by month and year
* Manage category budgets

### Reports

Provides:

* Daily reports
* Weekly reports
* Monthly reports
* Yearly reports
* Category breakdowns
* Spending comparisons
* Budget usage information

### Notifications

Allows users to:

* View notifications
* Filter unread notifications
* Mark notifications as read
* Mark all notifications as read
* Delete notifications

### Profile

Allows users to:

* View personal information
* Edit profile information
* Update phone number
* Update profile image URL
* View account role
* Logout

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

### 3. Start the backend

Make sure the Spring Boot backend is running on:

```text
http://localhost:8080
```

For Android Emulator, the Flutter application uses:

```text
http://10.0.2.2:8080
```

For Flutter Web, the application uses:

```text
http://localhost:8080
```

### 4. Run on Android

```bash
flutter run
```

### 5. Run on Chrome

```bash
flutter run -d chrome
```

---

## 🧪 Code Quality

Before committing changes, run:

```bash
flutter analyze
```

Format the project with:

```bash
dart format lib
```

To check outdated dependencies:

```bash
flutter pub outdated
```

---

## 📊 API Data Flow

The application follows a structured data flow:

```text
Presentation
      ↓
Repository
      ↓
Remote Data Source
      ↓
ApiClient / Dio
      ↓
Spring Boot REST API
      ↓
MySQL
```

Responses from the backend are converted into Flutter data models and then into domain entities for use by the application.

---

## 🔒 Security

Authentication data is protected using:

```text
flutter_secure_storage
```

JWT access tokens are stored securely and automatically added to authenticated API requests.

The application does not store JWT access tokens in regular shared preferences.

---

## 📂 Project Organization

The project separates responsibilities across different layers:

```text
Presentation
      ↓
Domain
      ↓
Data
      ↓
Backend API
```

This structure helps keep:

* UI logic separated from API communication
* API models separated from domain entities
* Networking centralized in one API client
* Error handling centralized
* Validation reusable
* Application styling consistent

---

## ✅ Current Development Status

The current Flutter foundation and main application features have been implemented.

### Completed

* Flutter project foundation
* Layered project architecture
* API constants
* Dio API client
* JWT authentication
* Secure token storage
* Error handling
* Application exceptions
* Validation utilities
* Domain entities
* Domain enums
* Data models
* Request models
* Remote data sources
* Repository contracts
* Repository implementations
* Riverpod providers
* Application theme
* Centralized colors
* Centralized text styles
* Shared loading widget
* Shared error widget
* Shared empty-state widget
* GoRouter navigation
* Login screen
* Register screen
* Dashboard screen
* Expenses screen
* Add expense screen
* Edit expense screen
* Income screen
* Add income screen
* Edit income screen
* Budgets screen
* Add budget screen
* Edit budget screen
* Reports screen
* Notifications screen
* Profile screen
* Responsive UI foundation
* Arabic / RTL-friendly interface
* Android configuration
* Flutter Web support

### Current Improvements

* Final UI/UX polish
* Additional responsive improvements
* Expanded automated testing
* Further architecture refinement
* Production release configuration

---

## 📱 Supported Platforms

The application is currently configured for:

* Android
* Web
* Windows development

The primary target is Android mobile application development.

---

## 👨‍💻 Developer

**Ayman Al-Jamal**

Computer Science Graduate

Backend & Mobile Application Development

---

## 📄 License

This project is currently intended for educational and development purposes.

A formal open-source license can be added later.

````
