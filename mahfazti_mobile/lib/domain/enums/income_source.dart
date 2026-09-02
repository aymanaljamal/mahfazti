enum IncomeSource {
  salary,
  freelance,
  allowance,
  gift,
  other,
}

extension IncomeSourceExtension on IncomeSource {
  String get value {
    switch (this) {
      case IncomeSource.salary:
        return 'SALARY';
      case IncomeSource.freelance:
        return 'FREELANCE';
      case IncomeSource.allowance:
        return 'ALLOWANCE';
      case IncomeSource.gift:
        return 'GIFT';
      case IncomeSource.other:
        return 'OTHER';
    }
  }

  static IncomeSource fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'SALARY':
        return IncomeSource.salary;
      case 'FREELANCE':
        return IncomeSource.freelance;
      case 'ALLOWANCE':
        return IncomeSource.allowance;
      case 'GIFT':
        return IncomeSource.gift;
      case 'OTHER':
        return IncomeSource.other;
      default:
        return IncomeSource.other;
    }
  }
}