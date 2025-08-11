import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/analysis_result.dart';

class AnalysisRepository {
  final String baseUrl;
  final Dio _dio;

  AnalysisRepository({required this.baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<AnalysisResult> analyzeDream(String text) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
    try {
      final resp = await _dio.post(
        '/api/v1/analyze',
        data: {'dream': text},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return AnalysisResult.fromJson(resp.data as Map<String, dynamic>);
    } catch (e, st) {
      log('analyzeDream error: $e', stackTrace: st);
      rethrow;
    }
  }
}
