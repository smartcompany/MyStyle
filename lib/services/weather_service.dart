import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../constants/api_constants.dart';

class WeatherService {
  WeatherService();

  Future<Weather> getCurrentWeather(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    try {
      // 우리 서버의 날씨 API 호출
      final uri = ApiConstants.weatherUri.replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      );
      final response = await http.get(uri, headers: {'X-Language': language});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 응답에서 current 부분만 추출
        return Weather.fromJson(data['current']);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // 서버 연결 실패 시 에러 재발생
      throw Exception('Weather API error: $e');
    }
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    try {
      final uri = ApiConstants.weatherUri.replace(
        queryParameters: {'city': cityName},
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Weather API error: $e');
    }
  }

  Future<WeatherForecast> getWeatherForecast(
    double latitude,
    double longitude, {
    String language = 'en',
  }) async {
    try {
      // weather API에서 예보 정보도 함께 가져옴
      final uri = ApiConstants.weatherUri.replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      );
      final response = await http.get(uri, headers: {'X-Language': language});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 응답에서 forecast 부분만 추출
        return WeatherForecast.fromJson(data['forecast']);
      } else {
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      // 서버 연결 실패 시 에러 재발생
      throw Exception('Weather forecast API error: $e');
    }
  }

  Future<WeatherForecast> getWeatherForecastByCity(String cityName) async {
    try {
      // 우리 서버의 예보 API 호출 (도시명으로)
      final uri = ApiConstants.forecastUri.replace(
        queryParameters: {'city': cityName},
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherForecast.fromJson(data);
      } else {
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      // 서버 연결 실패 시 에러 재발생
      throw Exception('Weather forecast API error: $e');
    }
  }
}
