import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiService {
  Future<String?> fetchIsOn() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://6703907dab8a8f892730a6d2.mockapi.io/api/v1/memorycardgame'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final bool isOn = data[0]['is_on'] ?? false;
          final String urlLink = data[0]['url'] ?? '';

          log("isOn : $isOn");

          if (isOn && await _isValidUrl(urlLink)) {
            return urlLink;
          } else {
            return "";
          }
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Future<bool> _isValidUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !['http', 'https'].contains(uri.scheme)) {
        return false;
      }

      final response = await http.get(uri);
      return response.statusCode == 200;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    } catch (e) {
      return false;
    }
  }
}
