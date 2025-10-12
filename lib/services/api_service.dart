import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ad_config.dart';
import '../models/analysis_result.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  AdConfig? _adConfig;
  bool _isConfigLoaded = false;

  void initialize() {}

  // Get ad configuration from server
  Future<AdConfig?> getAdConfig() async {
    try {
      final response = await http.get(
        ApiConstants.settingsUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _adConfig = AdConfig.fromJson(data);
        _isConfigLoaded = true;
        return _adConfig;
      } else {
        throw Exception('Failed to load ad config: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading ad config: $e');
      // Return fallback config if server fails
      return null;
    }
  }

  // Get platform-specific ad unit ID
  Future<String?> getRewardedAdUnitId() async {
    try {
      final response = await http.get(
        ApiConstants.settingsUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (Platform.isIOS) {
          final key = json['ios_ad'] as String?;
          final iosRef = json['ref']?['ios'] as Map<String, dynamic>?;
          if (key != null && iosRef != null && iosRef.containsKey(key)) {
            final value = iosRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        } else if (Platform.isAndroid) {
          final key = json['android_ad'] as String?;
          final androidRef = json['ref']?['android'] as Map<String, dynamic>?;
          if (key != null &&
              androidRef != null &&
              androidRef.containsKey(key)) {
            final value = androidRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        }
      }
    } catch (e) {
      print('광고 ID fetch 실패: $e');
    }
    return null;
  }

  Future<String?> getBannerAdUnitId() async {
    try {
      final response = await http.get(
        ApiConstants.settingsUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (Platform.isIOS) {
          final key = json['ios_banner_ad'] as String?;
          final iosRef = json['ref']?['ios'] as Map<String, dynamic>?;
          if (key != null && iosRef != null && iosRef.containsKey(key)) {
            final value = iosRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        } else if (Platform.isAndroid) {
          final key = json['android_banner_ad'] as String?;
          final androidRef = json['ref']?['android'] as Map<String, dynamic>?;
          if (key != null &&
              androidRef != null &&
              androidRef.containsKey(key)) {
            final value = androidRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        }
      }
    } catch (e) {
      print('배너 광고 ID fetch 실패: $e');
    }
    return null;
  }

  Future<String?> getInitialAdUnitId() async {
    try {
      final response = await http.get(
        ApiConstants.settingsUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (Platform.isIOS) {
          final key = json['ios_ad'] as String?;
          final iosRef = json['ref']?['ios'] as Map<String, dynamic>?;
          if (key != null && iosRef != null && iosRef.containsKey(key)) {
            final value = iosRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        } else if (Platform.isAndroid) {
          final key = json['android_ad'] as String?;
          final androidRef = json['ref']?['android'] as Map<String, dynamic>?;
          if (key != null &&
              androidRef != null &&
              androidRef.containsKey(key)) {
            final value = androidRef[key] as String?;
            if (value != null) {
              return value;
            }
          }
        }
      }
    } catch (e) {
      print('초기 광고 ID fetch 실패: $e');
    }
    return null;
  }

  // Clear cached config (useful for testing or when config changes)
  void clearConfigCache() {
    _adConfig = null;
    _isConfigLoaded = false;
  }

  // Analyze face image using OpenAI
  Future<AnalysisResult?> analyzeFace(
    String imagePath, {
    String? language,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('이미지 파일이 존재하지 않습니다.');
      }

      final request = http.MultipartRequest('POST', ApiConstants.analyzeUri);

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['type'] = 'face'; // 얼굴 분석 타입 추가

      if (ApiConstants.useDummy) {
        request.fields['useDummy'] = 'true';
      }

      // 언어 정보 추가
      if (language != null) {
        request.headers['X-Language'] = language;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('클라이언트에서 받은 얼굴 분석 결과: ${jsonEncode(data)}');
        return AnalysisResult.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        print('얼굴 분석 실패 응답: ${jsonEncode(errorData)}');
        throw Exception('분석 실패: ${errorData['error'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      print('얼굴 분석 오류: $e');
      return null;
    }
  }

  // Analyze full body image using OpenAI
  Future<Map<String, dynamic>?> analyzeFullBody(
    String imagePath, {
    String? language,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('이미지 파일이 존재하지 않습니다.');
      }

      final request = http.MultipartRequest('POST', ApiConstants.analyzeUri);

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.fields['type'] = 'fullbody'; // 전신 분석 타입 추가
      request.fields['useDummy'] = 'true'; // 테스트용 더미 데이터 사용

      // 언어 정보 추가
      if (language != null) {
        request.headers['X-Language'] = language;
      }

      if (ApiConstants.useDummy) {
        request.fields['useDummy'] = 'true';
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('클라이언트에서 받은 전신 분석 결과: ${jsonEncode(data)}');
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('전신 분석 실패 응답: ${jsonEncode(errorData)}');
        throw Exception('분석 실패: ${errorData['error'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      print('전신 분석 오류: $e');
      return null;
    }
  }
}
