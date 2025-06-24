import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:history_timeline/core/constants/app_constants.dart';

class GraphQLService {
  static String? _authToken;

  static void setAuthToken(String? token) {
    _authToken = token;
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.graphqlEndpoint),
        headers: _headers,
        body: json.encode({
          'query': query,
          'variables': variables ?? {},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        return result;
      } else {
        throw Exception('GraphQL query failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('GraphQL query error: $e');
    }
  }

  static Future<Map<String, dynamic>> mutate(
    String mutation, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.graphqlEndpoint),
        headers: _headers,
        body: json.encode({
          'query': mutation,
          'variables': variables ?? {},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        return result;
      } else {
        throw Exception('GraphQL mutation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('GraphQL mutation error: $e');
    }
  }

  // Mock method for testing UI without backend
  static Future<Map<String, dynamic>> mockQuery(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'data': {
        'events': [
          {'id': '1', 'title': 'Fall of Rome', 'year': 476},
          {'id': '2', 'title': 'Battle of Hastings', 'year': 1066},
        ]
      }
    };
  }
}
