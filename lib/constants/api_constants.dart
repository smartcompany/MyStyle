class ApiConstants {
  // Our Next.js API Server
  // 프로덕션: https://your-production-domain.vercel.app
  // 개발: http://localhost:3000
  static const String _apiBaseUrl = 'https://my-style-server-chi.vercel.app';

  static final Uri weatherUri = Uri.parse('$_apiBaseUrl/api/weather');
  static final Uri forecastUri = Uri.parse('$_apiBaseUrl/api/forecast');

  // URI constants - use static final instead of const
  static final Uri analyzeUri = Uri.parse('$_apiBaseUrl/api/analyze');
  static final Uri settingsUri = Uri.parse('$_apiBaseUrl/api/settings');
}
