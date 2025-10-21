class ApiConstants {
  // Our Next.js API Server
  // 프로덕션: https://my-style-server-chi.vercel.app
  // 개발: http://localhost:3005
  static const bool useDummy = false;
  static const String apiBaseUrl = 'https://my-style-server-chi.vercel.app';

  // Weather Endpoints
  static final Uri weatherUri = Uri.parse('$apiBaseUrl/api/weather');
  static final Uri forecastUri = Uri.parse('$apiBaseUrl/api/forecast');

  // Analysis Endpoints
  static final Uri analyzeUri = Uri.parse('$apiBaseUrl/api/analyze');
  static final Uri settingsUri = Uri.parse('$apiBaseUrl/api/settings');
}
