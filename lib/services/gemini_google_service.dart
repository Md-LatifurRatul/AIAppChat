import 'dart:io';
import 'package:aigeminiapp/secret_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class GeminiGoogleService {
  late GenerativeModel model;
  late ChatSession chat;
  List<Content> conversationHistory = [];
  // final String _modelName = 'gemini-1.5-flash-latest';

  // final String _modelName1 = 'gemini-pro-vision';
  // final String _modelName2 = 'gemini-1.5-pro';
  final String _modelName3 = "gemini-2.0-flash";
  GeminiGoogleService() {
    model = GenerativeModel(
      model: _modelName3,
      apiKey: SecretKey.apiKey,
    );
    chat = model.startChat();
  }

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

  Future<String?> getResponseChat(String userMessage) async {
    try {
      final response = await chat.sendMessage(Content.text(userMessage));

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text;
      } else {
        return 'No response received';
      }
    } catch (e) {
      print('Error from Gemini: $e');
      return 'Error processing request';
    }
  }

  Stream<GenerateContentResponse> generateContentStreamChat(
      String userMessage) {
    return chat.sendMessageStream(Content.text(userMessage));
  }
}
