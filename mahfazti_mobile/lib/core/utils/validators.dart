class Validators {
  Validators._();

  // =========================================================
  // REQUIRED
  // =========================================================

  static String? required(
    String? value, {
    String fieldName = 'هذا الحقل',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب.';
    }

    return null;
  }

  // =========================================================
  // NAME
  // =========================================================

  static String? name(
    String? value, {
    String fieldName = 'الاسم',
  }) {
    final requiredError = required(
      value,
      fieldName: fieldName,
    );

    if (requiredError != null) {
      return requiredError;
    }

    final trimmedValue = value!.trim();

    if (trimmedValue.length < 2) {
      return '$fieldName يجب أن يحتوي على حرفين على الأقل.';
    }

    return null;
  }

  // =========================================================
  // EMAIL
  // =========================================================

  static String? email(String? value) {
    final requiredError = required(
      value,
      fieldName: 'البريد الإلكتروني',
    );

    if (requiredError != null) {
      return requiredError;
    }

    final emailRegex = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return 'أدخل بريدًا إلكترونيًا صحيحًا.';
    }

    return null;
  }

  // =========================================================
  // PASSWORD
  // =========================================================

  static String? password(String? value) {
    final requiredError = required(
      value,
      fieldName: 'كلمة المرور',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < 8) {
      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل.';
    }

    return null;
  }

  // =========================================================
  // CONFIRM PASSWORD
  // =========================================================

  static String? confirmPassword(
    String? value,
    String? passwordValue,
  ) {
    final requiredError = required(
      value,
      fieldName: 'تأكيد كلمة المرور',
    );

    if (requiredError != null) {
      return requiredError;
    }

    if (value != passwordValue) {
      return 'كلمتا المرور غير متطابقتين.';
    }

    return null;
  }

  // =========================================================
  // PHONE
  // =========================================================

  static String? phone(String? value) {
    final requiredError = required(
      value,
      fieldName: 'رقم الهاتف',
    );

    if (requiredError != null) {
      return requiredError;
    }

    final phoneRegex = RegExp(
      r'^(?:\+970|970|059|056)[0-9]{7}$',
    );

    final normalizedPhone = value!
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');

    if (!phoneRegex.hasMatch(normalizedPhone)) {
      return 'أدخل رقم هاتف فلسطيني صحيح.';
    }

    return null;
  }

  // =========================================================
  // AMOUNT
  // =========================================================

  static String? amount(
    String? value, {
    String fieldName = 'المبلغ',
  }) {
    final requiredError = required(
      value,
      fieldName: fieldName,
    );

    if (requiredError != null) {
      return requiredError;
    }

    final parsedAmount = double.tryParse(
      value!.trim(),
    );

    if (parsedAmount == null) {
      return '$fieldName يجب أن يكون رقمًا صحيحًا.';
    }

    if (parsedAmount <= 0) {
      return '$fieldName يجب أن يكون أكبر من صفر.';
    }

    return null;
  }

  // =========================================================
  // DESCRIPTION
  // =========================================================

  static String? description(
    String? value, {
    int maxLength = 500,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length > maxLength) {
      return 'الوصف يجب ألا يتجاوز $maxLength حرف.';
    }

    return null;
  }

  // =========================================================
  // INTEGER
  // =========================================================

  static String? integer(
    String? value, {
    String fieldName = 'القيمة',
    int? min,
    int? max,
  }) {
    final requiredError = required(
      value,
      fieldName: fieldName,
    );

    if (requiredError != null) {
      return requiredError;
    }

    final parsedValue = int.tryParse(
      value!.trim(),
    );

    if (parsedValue == null) {
      return '$fieldName يجب أن يكون رقمًا صحيحًا.';
    }

    if (min != null && parsedValue < min) {
      return '$fieldName يجب أن يكون $min أو أكبر.';
    }

    if (max != null && parsedValue > max) {
      return '$fieldName يجب أن يكون $max أو أقل.';
    }

    return null;
  }

  // =========================================================
  // YEAR
  // =========================================================

  static String? year(String? value) {
    return integer(
      value,
      fieldName: 'السنة',
      min: 2000,
      max: 2100,
    );
  }

  // =========================================================
  // MONTH
  // =========================================================

  static String? month(String? value) {
    return integer(
      value,
      fieldName: 'الشهر',
      min: 1,
      max: 12,
    );
  }
}