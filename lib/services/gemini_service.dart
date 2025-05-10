import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyAAFcBdEDHDgsjikw5JQAFkmvxGFrhYHAo';
  final String url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

  Future<String> sendChat(
      List<Map<String, String>> history, String systemPrompt) async {
    final List<Map<String, dynamic>> contentParts = [];

    // Include system prompt as a user message
    if (systemPrompt.isNotEmpty) {
      contentParts.add({
        "role": "user",
        "parts": [
          {"text": systemPrompt}
        ]
      });
    }

    // Add user & model messages from history
    for (var msg in history) {
      contentParts.add({
        "role": msg['role'],
        "parts": [
          {"text": msg['text']}
        ]
      });
    }

    final body = jsonEncode({
      "contents": contentParts,
    });

    final response = await http.post(
      Uri.parse('$url$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Gemini API error: ${response.body}');
    }
  }
}
