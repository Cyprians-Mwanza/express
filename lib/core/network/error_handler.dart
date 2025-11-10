import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure fromDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      String message = 'An unknown error occurred';

      if (data != null) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            message = data['message'];
          } else if (data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map<String, dynamic>) {
              message = errors.values.map((v) => v.toString()).join(', ');
            }
          }
        } else if (data is String) {
          message = data;
        }
      }
      return Failure(message, statusCode: statusCode);
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return Failure('Connection timed out');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return Failure('Receive timeout');
    } else if (e.type == DioExceptionType.badCertificate) {
      return Failure('Invalid SSL certificate');
    } else if (e.type == DioExceptionType.connectionError) {
      return Failure('No internet connection');
    } else {
      return Failure('Unexpected error occurred');
    }
  }
}
