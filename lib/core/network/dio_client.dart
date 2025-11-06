import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;
  final _storage = const FlutterSecureStorage();

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.kuzadev.online',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'FlutterApp',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print(' REQUEST[${options.method}] => PATH: ${options.uri}');
          print('Headers: ${options.headers}');
          print('Body: ${options.data}');
          return handler.next(options);
        },
        onError: (error, handler) {
          print(' ERROR[${error.response?.statusCode}] => ${error.message}');
          if (error.response != null) {
            print('Response Data: ${error.response?.data}');
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          print(' RESPONSE[${response.statusCode}] => ${response.data}');
          return handler.next(response);
        },
      ),
    );

    // 🔍 Add this LogInterceptor for full Dio-level logging (temporary)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print('🛰 $obj'),
      ),
    );
  }
}
