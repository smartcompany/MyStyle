import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _currentWeather;
  WeatherForecast? _weatherForecast;
  bool _isLoading = false;
  String? _error;

  Weather? get currentWeather => _currentWeather;
  WeatherForecast? get weatherForecast => _weatherForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getWeatherByCity(String cityName) async {
    _setLoading(true);
    _clearError();

    try {
      _currentWeather = await _weatherService.getWeatherByCity(cityName);
      notifyListeners();
    } catch (e) {
      _setError('날씨 정보를 가져올 수 없습니다: $e');
    }

    _setLoading(false);
  }

  Future<void> refreshWeather({String language = 'en'}) async {
    if (_currentWeather != null) {
      await getCurrentLocationWeather(language: language);
    }
  }

  Future<void> _fetchWeatherData(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    try {
      // 현재 날씨와 예보를 동시에 가져오기
      final results = await Future.wait([
        _weatherService.getCurrentWeather(
          latitude,
          longitude,
          language: language,
        ),
        _weatherService.getWeatherForecast(
          latitude,
          longitude,
          language: language,
        ),
      ]);

      _currentWeather = results[0] as Weather;
      _weatherForecast = results[1] as WeatherForecast;

      notifyListeners();
    } catch (e) {
      _setError('날씨 정보를 가져올 수 없습니다: $e');
    }
  }

  Future<void> getCurrentLocationWeather({String language = 'en'}) async {
    _setLoading(true);
    _clearError();

    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        await _fetchWeatherData(
          position.latitude,
          position.longitude,
          language: language,
        );
      } else {
        _setError('위치를 가져올 수 없습니다.');
      }
    } catch (e) {
      _setError('위치 권한이 필요합니다: $e');
    }

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearWeather() {
    _currentWeather = null;
    _weatherForecast = null;
    _error = null;
    notifyListeners();
  }
}
