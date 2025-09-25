import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ad_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String _baseUrl = 'https://my-style-server-chi.vercel.app';
  AdConfig? _adConfig;
  bool _isConfigLoaded = false;

  void initialize({String baseUrl = 'https://my-style-server-chi.vercel.app'}) {
    _baseUrl = baseUrl;
  }

  // Get ad configuration from server
  Future<AdConfig?> getAdConfig() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/settings'),
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
        Uri.parse('$_baseUrl/api/settings'),
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
        Uri.parse('$_baseUrl/api/settings'),
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
        Uri.parse('$_baseUrl/api/settings'),
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
}
