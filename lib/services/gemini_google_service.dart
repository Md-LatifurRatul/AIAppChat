import 'dart:io';
import 'package:aigeminiapp/secret_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

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

  Future<String?> getResponseWithImage(String prompt, File imageFile) async {
    try {
      final imageData = await imageFile.readAsBytes();
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      final content = Content.multi([
        TextPart(prompt),
        DataPart(mimeType, imageData),
      ]);
      final response = await model.generateContent([content]);

      print(response.text);
      return response.text;
    } catch (e) {
      print('Error from google_generative_ai (image): ${e.toString()}');
      return null;
    }
  }
}
