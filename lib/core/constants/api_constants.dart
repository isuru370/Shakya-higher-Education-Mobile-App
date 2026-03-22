class ApiConstants {
  static const String baseUrl = 'https://shakyaeducation.nexorait.lk';
  //http://10.191.103.230:8000
  //https://shakyaeducation.nexorait.lk
  static const String apiUrl = '$baseUrl/api';

  static const String login = '$apiUrl/login';
  static const String logout = '$apiUrl/logout';
  static const String profile = '$apiUrl/profile';

  // headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';

  static Map<String, String> headers({String? token}) {
    final headers = {contentType: applicationJson, accept: applicationJson};

    if (token != null && token.isNotEmpty) {
      headers[authorization] = 'Bearer $token';
    }

    return headers;
  }
}
