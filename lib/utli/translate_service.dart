import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TranslateService {
  // final String apiKey;

  TranslateService();

  String apiKey = dotenv.get('SARVAM_API_KEY', fallback: "");

  Future<String> translateText(String input, String targetLanguage) async {
    final url = Uri.parse('https://api.sarvam.ai/translate');
    if (apiKey == "") {
      throw Exception('API key not found');
    }
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'api-subscription-key': apiKey,
      },
      body: jsonEncode({
        'input': input,
        'source_language_code': 'en-IN',
        'target_language_code': targetLanguage,
        'mode': 'code-mixed',
        "speaker_gender": "Male",
        "model": "mayura:v1",
        "enable_preprocessing": false
      }),
    );
    // print(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      // print(response.body);
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['translated_text'];
    } else {
      // throw Exception('Failed to translate text' +
      //     response.body +
      //     response.statusCode.toString() +
      //     response.reasonPhrase.toString());
      return input;
    }
  }
}
