import 'package:aigeminiapp/secret_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiGoogleService {
  late GenerativeModel model;

  GeminiGoogleService()
      : model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: SecretKey.apiKey,
        );

  Future<String?> getResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      print(response.text);
      return response.text;
    } catch (e) {
      print('Error from google_generative_ai: ${e.toString()}');
      return null;
    }
  }
}
