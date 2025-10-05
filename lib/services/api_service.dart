import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/math_problem.dart';
import '../utils/app_config.dart';

class ApiService {
  static String get baseUrl => AppConfig.apiBaseUrl;
  final Dio _dio;
  String? _authToken;
  String? _userId;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        debugPrint('🚀 Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('❌ Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
        debugPrint('❌ Error message: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  void setAuthToken(String token, String userId) {
    _authToken = token;
    _userId = userId;
    debugPrint('🔐 Auth token set for user: $userId');
  }

  void clearAuth() {
    _authToken = null;
    _userId = null;
    debugPrint('🔓 Auth cleared');
  }

  String? get userId => _userId;
  bool get isAuthenticated => _authToken != null;

  // Upload PDF
  Future<Map<String, dynamic>> uploadPDF(File pdfFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          pdfFile.path,
          filename: pdfFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      debugPrint('📤 PDF uploaded successfully');
      return response.data;
    } on DioException catch (e) {
      debugPrint('❌ Upload error: ${e.message}');
      throw _handleError(e);
    }
  }

  // Check upload status
  Future<Map<String, dynamic>> checkUploadStatus(String problemId) async {
    try {
      final response = await _dio.get('/upload/status/$problemId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get user's problems
  Future<List<Map<String, dynamic>>> getUserProblems() async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await _dio.get('/problems/$_userId');
      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get specific problem
  Future<Map<String, dynamic>> getProblem(String problemId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await _dio.get('/problems/$_userId/$problemId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete problem
  Future<void> deleteProblem(String problemId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _dio.delete('/problems/$_userId/$problemId');
      debugPrint('🗑️ Problem deleted: $problemId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Solve problem
  Future<Map<String, dynamic>> solveProblem(String problemId) async {
    try {
      final response = await _dio.post('/solve/$problemId');
      debugPrint('🧮 Problem solving initiated: $problemId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Solve expression directly
  Future<Map<String, dynamic>> solveExpression(String expression) async {
    try {
      final response = await _dio.post(
        '/solve/expression',
        data: {'expression': expression},
      );
      debugPrint('🧮 Expression solved: $expression');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get solutions for a problem
  Future<List<Solution>> getProblemSolutions(String problemId) async {
    try {
      final response = await _dio.get('/solve/$problemId/solutions');
      final List<dynamic> data = response.data;
      return data.map((json) => Solution.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get specific solution
  Future<Solution> getSolution(String solutionId) async {
    try {
      final response = await _dio.get('/solve/solution/$solutionId');
      return Solution.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Check solution status
  Future<Map<String, dynamic>> checkSolutionStatus(String solutionId) async {
    try {
      final response = await _dio.get('/solve/solution/$solutionId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data['detail'] ?? e.response!.data['message'] ?? 'Unknown error';
      
      switch (statusCode) {
        case 400:
          return 'Bad request: $message';
        case 401:
          return 'Unauthorized: Please sign in again';
        case 403:
          return 'Forbidden: You don\'t have permission';
        case 404:
          return 'Not found: $message';
        case 500:
          return 'Server error: $message';
        default:
          return 'Error ($statusCode): $message';
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check if the backend is running.';
    }
    
    return 'Network error: ${e.message}';
  }
}
