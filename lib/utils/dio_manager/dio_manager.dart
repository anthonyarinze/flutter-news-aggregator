import 'dart:convert';

import 'package:dio/dio.dart';

import 'dio_interceptor.dart';

class DioManager {
  static Map<String, dynamic> baseHeader = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };

  final Dio _dio = Dio(
    BaseOptions(
      headers: baseHeader,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  Dio get dioInstance => _dio;

  Future<void> _initialiseDIO() async {
    _dio.interceptors.add(DIOInterceptors());
  }

  Future<Map<String, dynamic>?> post(String url, {required data}) async =>
      await _initialiseDIO().then((value) async => await _dio.post(url, data: data).then((response) => json.decode(response.data)));

  Future<Map<String, dynamic>?> get(String url, {Map<String, dynamic>? queryParameters}) async {
    await _initialiseDIO();
    final response = await _dio.get(url, queryParameters: queryParameters);
    if (response.statusCode == 200) {
      return response.data; // The response.data is already a Map<String, dynamic>
    } else {
      throw DioException(message: 'Request failed with status ${response.statusCode}', requestOptions: RequestOptions());
    }
  }
}
