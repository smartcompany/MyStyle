import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_analysis.dart';
import '../models/weather.dart';
import '../models/user_preferences.dart';
import '../constants/api_constants.dart';

/// 사진 분석 서비스 - AI 기반 스타일 분석
class PhotoAnalysisService {
  /// 전신 사진 분석 및 코디 추천
  Future<PhotoAnalysisResponse> analyzePhotoAndRecommend({
    required File photoFile,
    required Weather currentWeather,
    required UserPreferences userPreferences,
    String? userId,
    String stylePreset = 'casual',
    List<String>? recommendedItems,
    String? imageUrl,
    String type = 'face',
  }) async {
    try {
      // multipart 요청 생성
      final uri = ApiConstants.analyzeUri;
      final request = http.MultipartRequest('POST', uri);

      // 이미지 파일 추가
      request.files.add(
        await http.MultipartFile.fromPath('image', photoFile.path),
      );

      // 폼 데이터 추가
      request.fields['type'] = type; // 서버에서 'type' 파라미터로 받음
      request.fields['stylePreset'] = stylePreset;
      request.fields['recommendedItems'] = recommendedItems?.join(',') ?? '';
      request.fields['weatherSummary'] = _summarizeWeather(currentWeather);
      request.fields['location'] = currentWeather.location;
      request.fields['preferredLanguage'] = userPreferences.preferredLanguage;
      request.fields['imageUrl'] = imageUrl ?? '';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📡 서버 응답 상태: ${response.statusCode}');
      print('📡 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📡 파싱된 데이터: $data');

        if (data['success'] == true && data['data'] != null) {
          return PhotoAnalysisResponse.fromJson(data['data']);
        } else {
          throw PhotoAnalysisException(
            '서버에서 실패 응답을 반환했습니다: ${data['error'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw PhotoAnalysisException(
          '사진 분석에 실패했습니다. 상태 코드: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw PhotoAnalysisException('사진 분석 중 오류가 발생했습니다: $e');
    }
  }

  String _summarizeWeather(Weather weather) {
    return 'temperature : ${weather.temperature.toStringAsFixed(0)} C, feelsLike : ${weather.feelsLike.toStringAsFixed(0)} C, humidity : ${weather.humidity}%, windSpeed : ${weather.windSpeed} m/s, main : ${weather.main}, desc : ${weather.description}, location : ${weather.location}';
  }

  /// 분석 히스토리 저장 (로컬)
  Future<void> saveAnalysisHistory(PhotoAnalysisResponse analysis) async {
    // TODO: SharedPreferences 또는 SQLite로 히스토리 저장
    try {
      // 구현 예정
      print('📱 분석 결과 로컬 저장: ${analysis.imageUrl}');
    } catch (e) {
      print('⚠️ 히스토리 저장 실패: $e');
    }
  }

  /// 분석 히스토리 조회 (로컬)
  Future<List<PhotoAnalysisResponse>> getAnalysisHistory() async {
    // TODO: 저장된 히스토리 조회
    try {
      // 구현 예정
      return [];
    } catch (e) {
      print('⚠️ 히스토리 조회 실패: $e');
      return [];
    }
  }
}

/// 사진 분석 예외
class PhotoAnalysisException implements Exception {
  final String message;

  PhotoAnalysisException(this.message);

  @override
  String toString() => 'PhotoAnalysisException: $message';
}
