import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiFlutterService {
  final Gemini gemini = Gemini.instance;

  Future<String?> getResponse(String prompt) async {
    try {
      final response = await gemini.prompt(parts: [
        Part.text(prompt),
      ]);
      print(response?.output);

      return response?.output;
    } catch (e) {
      print('Error from flutter_gemini: ${e.toString()}');
      return null;
    }
  }
}
