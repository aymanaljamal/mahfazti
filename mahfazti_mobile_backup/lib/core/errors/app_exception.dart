class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AppException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() {
    return message;
  }
}

// =========================================================
// NETWORK EXCEPTION
// =========================================================

class NetworkException extends AppException {
  const NetworkException({
    String message = 'تعذر الاتصال بالخادم.',
    String? code,
  }) : super(
          message: message,
          code: code,
        );
}

// =========================================================
// SERVER EXCEPTION
// =========================================================

class ServerException extends AppException {
  const ServerException({
    String message = 'حدث خطأ في الخادم.',
    String? code,
    int? statusCode,
  }) : super(
          message: message,
          code: code,
          statusCode: statusCode,
        );
}

// =========================================================
// AUTH EXCEPTION
// =========================================================

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.',
  }) : super(
          message: message,
          code: 'UNAUTHORIZED',
          statusCode: 401,
        );
}

// =========================================================
// FORBIDDEN EXCEPTION
// =========================================================

class ForbiddenException extends AppException {
  const ForbiddenException({
    String message = 'ليس لديك صلاحية لتنفيذ هذا الطلب.',
  }) : super(
          message: message,
          code: 'FORBIDDEN',
          statusCode: 403,
        );
}

// =========================================================
// NOT FOUND EXCEPTION
// =========================================================

class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'العنصر المطلوب غير موجود.',
  }) : super(
          message: message,
          code: 'NOT_FOUND',
          statusCode: 404,
        );
}

// =========================================================
// VALIDATION EXCEPTION
// =========================================================

class ValidationException extends AppException {
  const ValidationException({
    String message = 'البيانات المدخلة غير صحيحة.',
    String? code,
    int? statusCode,
  }) : super(
          message: message,
          code: code,
          statusCode: statusCode ?? 400,
        );
}

// =========================================================
// CONFLICT EXCEPTION
// =========================================================

class ConflictException extends AppException {
  const ConflictException({
    String message = 'يوجد تعارض في البيانات.',
  }) : super(
          message: message,
          code: 'CONFLICT',
          statusCode: 409,
        );
}

// =========================================================
// UNKNOWN EXCEPTION
// =========================================================

class UnknownException extends AppException {
  const UnknownException({
    String message = 'حدث خطأ غير متوقع.',
  }) : super(
          message: message,
          code: 'UNKNOWN',
        );
}
