import 'package:dotenv/dotenv.dart';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAiService extends Endpoint {
  Future<String> generateImage(Session session, String prompt) async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    final apiKey = env['API_KEY'];
    final url = Uri.parse('https://api.openai.com/v1/images/generations');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "dall-e-3",
        "prompt": prompt,
        "n": 1,
        "size": "1024x1024",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imageUrl = data['data'][0]['url'];
      return imageUrl;
    } else {
      throw Exception('Failed to generate image');
    }
  }
}
