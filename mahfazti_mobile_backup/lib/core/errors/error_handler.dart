import 'package:dio/dio.dart';

import 'app_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  // =========================================================
  // HANDLE DIO EXCEPTION
  // =========================================================
  static AppException handleDioException(
    DioException exception,
  ) {
    switch (exception.type) {
      // -------------------------------------------------------
      // CONNECTION TIMEOUT
      // -------------------------------------------------------

      case DioExceptionType.connectionTimeout:
        return const NetworkException(
          message: 'انتهت مهلة الاتصال بالخادم.',
        );

      // -------------------------------------------------------
      // SEND TIMEOUT
      // -------------------------------------------------------

      case DioExceptionType.sendTimeout:
        return const NetworkException(
          message: 'انتهت مهلة إرسال الطلب.',
        );

      // -------------------------------------------------------
      // RECEIVE TIMEOUT
      // -------------------------------------------------------

      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'انتهت مهلة استلام البيانات.',
        );

      // -------------------------------------------------------
      // TRANSFORM TIMEOUT
      // -------------------------------------------------------

      case DioExceptionType.transformTimeout:
        return const NetworkException(
          message: 'انتهت مهلة معالجة البيانات.',
        );

      // -------------------------------------------------------
      // CONNECTION ERROR
      // -------------------------------------------------------

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'تعذر الاتصال بالخادم. تأكد أن الخادم يعمل.',
        );

      // -------------------------------------------------------
      // BAD RESPONSE
      // -------------------------------------------------------

      case DioExceptionType.badResponse:
        return _handleStatusCode(exception);

      // -------------------------------------------------------
      // REQUEST CANCELLED
      // -------------------------------------------------------

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'تم إلغاء الطلب.',
        );

      // -------------------------------------------------------
      // BAD CERTIFICATE
      // -------------------------------------------------------

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'حدثت مشكلة في شهادة الاتصال.',
        );

      // -------------------------------------------------------
      // UNKNOWN
      // -------------------------------------------------------

      case DioExceptionType.unknown:
        return const UnknownException();

      // -------------------------------------------------------
      // FUTURE / UNEXPECTED TYPES
      // -------------------------------------------------------

      default:
        return const UnknownException(
          message: 'حدث خطأ غير متوقع أثناء الاتصال بالخادم.',
        );
    }
  }
  // =========================================================
  // HANDLE HTTP STATUS CODE
  // =========================================================

  static AppException _handleStatusCode(
    DioException exception,
  ) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    final message = _extractMessage(data);

    switch (statusCode) {
      // -------------------------------------------------------
      // 400 BAD REQUEST
      // -------------------------------------------------------

      case 400:
        return ValidationException(
          message: message ?? 'البيانات المرسلة غير صحيحة.',
          statusCode: statusCode,
        );

      // -------------------------------------------------------
      // 401 UNAUTHORIZED
      // -------------------------------------------------------

      case 401:
        return UnauthorizedException(
          message: message ?? 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        );

      // -------------------------------------------------------
      // 403 FORBIDDEN
      // -------------------------------------------------------

      case 403:
        return ForbiddenException(
          message: message ?? 'ليس لديك صلاحية لتنفيذ هذا الطلب.',
        );

      // -------------------------------------------------------
      // 404 NOT FOUND
      // -------------------------------------------------------

      case 404:
        return NotFoundException(
          message: message ?? 'العنصر المطلوب غير موجود.',
        );

      // -------------------------------------------------------
      // 409 CONFLICT
      // -------------------------------------------------------

      case 409:
        return ConflictException(
          message: message ?? 'يوجد تعارض في البيانات.',
        );

      // -------------------------------------------------------
      // 422 UNPROCESSABLE ENTITY
      // -------------------------------------------------------

      case 422:
        return ValidationException(
          message: message ?? 'البيانات المدخلة غير صالحة.',
          statusCode: statusCode,
        );

      // -------------------------------------------------------
      // 500 INTERNAL SERVER ERROR
      // -------------------------------------------------------

      case 500:
        return ServerException(
          message: message ?? 'حدث خطأ داخلي في الخادم.',
          statusCode: statusCode,
        );

      // -------------------------------------------------------
      // OTHER SERVER ERRORS
      // -------------------------------------------------------

      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message ?? 'حدث خطأ في الخادم. حاول مرة أخرى.',
            statusCode: statusCode,
          );
        }

        return UnknownException(
          message: message ?? 'حدث خطأ أثناء تنفيذ الطلب.',
        );
    }
  }

  // =========================================================
  // EXTRACT MESSAGE
  // =========================================================

  static String? _extractMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }

    // Spring Boot / ApiResponse
    final message = data['message'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    // بعض الأخطاء قد ترجع error
    final error = data['error'];

    if (error is String && error.trim().isNotEmpty) {
      return error;
    }

    // validation errors
    final errors = data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is String) {
        return firstError;
      }
    }

    return null;
  }
}
