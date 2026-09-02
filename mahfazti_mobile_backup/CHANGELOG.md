
### `CHANGELOG.md`

وهذا الأفضل يكون فيه سجل حقيقي حسب المرحلة الحالية بدل ما نظل حاطين كل شيء `In Progress`:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on the principles of Semantic Versioning.

---

## [Unreleased]

### Added

#### Project Foundation

- Flutter application foundation
- Layered Clean Architecture-inspired project structure
- Core application configuration
- API constants
- Centralized exception handling
- Validation utilities

#### Networking

- Dio-based API client
- Centralized API configuration
- Request timeout configuration
- JWT Authorization header support
- Automatic access token attachment

#### Authentication

- Login screen
- Registration screen
- JWT authentication flow
- Secure access token storage
- Local session management
- Logout functionality

#### Domain Layer

- User entity
- Income entity
- Expense entity
- Budget entity
- Category entity
- Notification entity
- Financial report entities
- User role enum
- Income source enum
- Payment method enum
- Notification type enum

#### Data Layer

- Authentication models
- User models
- Income models
- Expense models
- Budget models
- Category models
- Notification models
- Financial report models
- Request models
- Remote data sources
- Repository interfaces
- Repository implementations

#### State Management

- Riverpod integration
- Application providers
- Repository dependency injection
- Category list provider

#### Navigation

- GoRouter integration
- Authentication routes
- Dashboard route
- Expense routes
- Income routes
- Budget routes
- Reports route
- Notifications route
- Profile route
- Router error screen

#### UI & Theme

- Material 3 application theme
- Centralized application colors
- Centralized typography
- Arabic-friendly UI
- RTL-friendly layouts
- Shared loading widget
- Shared error widget
- Shared empty-state widget
- Consistent form styling
- Responsive UI foundation

#### Screens

- Login screen
- Register screen
- Dashboard screen
- Expenses screen
- Add expense screen
- Edit expense screen
- Income screen
- Add income screen
- Edit income screen
- Budgets screen
- Add budget screen
- Edit budget screen
- Reports screen
- Notifications screen
- Profile screen

#### Finance Features

- Income management
- Expense management
- Budget management
- Date filtering
- Category filtering
- Payment method support
- Income source support
- Expense summary
- Budget usage tracking

#### Reports

- Daily reports
- Weekly reports
- Monthly reports
- Yearly reports
- Category breakdown
- Spending comparisons
- Average daily spending
- Highest spending day
- Previous period comparisons
- Budget usage percentage

#### Notifications

- Notification listing
- Unread notifications
- Unread count
- Mark single notification as read
- Mark all notifications as read
- Delete notifications
- Budget warning notifications
- Budget exceeded notifications
- Other backend notification types

#### Profile

- View current user
- Update personal information
- Phone number update
- Profile image URL support
- User role display
- Logout

#### Platform Configuration

- Android minimum SDK configured for required dependencies
- Android compile SDK configured for current dependencies
- Flutter Web support
- Android emulator API configuration
- Flutter launcher icon configuration

---

### Fixed

- Fixed Riverpod `ProviderScope` initialization
- Fixed Android minimum SDK compatibility with `flutter_secure_storage`
- Fixed Android compile SDK configuration
- Fixed Flutter Web API base URL
- Fixed wrapped `ApiResponse` parsing for income responses
- Fixed wrapped `ApiResponse` parsing for budget responses
- Fixed duplicate `EditExpenseScreen` naming conflict
- Fixed income routing configuration
- Fixed Arabic date formatting initialization

---

### In Progress

- Final visual refinements
- Expanded automated widget and integration tests
- Additional responsive improvements
- Authentication route guards
- Production release configuration
- Further Clean Architecture refinement

---

## [0.1.0] - Development Foundation

### Added

- Initial Flutter project
- Core application architecture
- API integration foundation
- Authentication foundation
- Finance management foundation
- Dashboard foundation
- Routing foundation
- Shared UI components
- Application theme
