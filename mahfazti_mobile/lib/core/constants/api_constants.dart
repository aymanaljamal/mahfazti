class ApiConstants {
  ApiConstants._();

  // =========================================================
  // BASE URL
  // =========================================================

  // Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8080';

  // =========================================================
  // AUTH
  // =========================================================

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // =========================================================
  // USER
  // =========================================================

  static const String currentUser = '/api/users/me';

  // =========================================================
  // CATEGORIES
  // =========================================================

  static const String categories = '/api/categories';

  // =========================================================
  // EXPENSES
  // =========================================================

  static const String expenses = '/api/expenses';

  static const String expenseSummary =
      '/api/expenses/summary';

  // =========================================================
  // INCOMES
  // =========================================================

  static const String incomes = '/api/incomes';

  // =========================================================
  // BUDGETS
  // =========================================================

  static const String budgets = '/api/budgets';

  // =========================================================
  // NOTIFICATIONS
  // =========================================================

  static const String notifications =
      '/api/notifications';

  static const String unreadNotifications =
      '/api/notifications/unread';

  static const String unreadNotificationsCount =
      '/api/notifications/unread-count';

  static const String markNotificationAsRead =
      '/api/notifications/{id}/read';

  static const String markAllNotificationsRead =
      '/api/notifications/read-all';

  // =========================================================
  // REPORTS
  // =========================================================

  static const String dailyReport =
      '/api/reports/daily';

  static const String weeklyReport =
      '/api/reports/weekly';

  static const String monthlyReport =
      '/api/reports/monthly';

  static const String yearlyReport =
      '/api/reports/yearly';
}