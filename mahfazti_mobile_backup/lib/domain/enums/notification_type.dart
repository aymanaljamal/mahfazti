enum NotificationType {
  budgetWarning,
  budgetExceeded,
  goalProgress,
  reminder,
  monthlyReport,
  unusualSpending,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.budgetWarning:
        return 'BUDGET_WARNING';
      case NotificationType.budgetExceeded:
        return 'BUDGET_EXCEEDED';
      case NotificationType.goalProgress:
        return 'GOAL_PROGRESS';
      case NotificationType.reminder:
        return 'REMINDER';
      case NotificationType.monthlyReport:
        return 'MONTHLY_REPORT';
      case NotificationType.unusualSpending:
        return 'UNUSUAL_SPENDING';
    }
  }

  static NotificationType fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'BUDGET_WARNING':
        return NotificationType.budgetWarning;
      case 'BUDGET_EXCEEDED':
        return NotificationType.budgetExceeded;
      case 'GOAL_PROGRESS':
        return NotificationType.goalProgress;
      case 'REMINDER':
        return NotificationType.reminder;
      case 'MONTHLY_REPORT':
        return NotificationType.monthlyReport;
      case 'UNUSUAL_SPENDING':
        return NotificationType.unusualSpending;
      default:
        return NotificationType.reminder;
    }
  }
}
