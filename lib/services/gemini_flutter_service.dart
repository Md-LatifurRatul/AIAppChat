import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiFlutterService {
  final Gemini gemini = Gemini.instance;
  List<Content> contentList = [];

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

  // Future<Candidates?> getResponseChat(String prompt) async {
  //   try {
  //     contentList.add(
  //       Content(parts: [
  //         Parts(
  //           text: prompt,
  //         )
  //       ], role: 'user'),
  //     );

  //     final response = gemini.chat(contentList);
  //     return response;
  //   } catch (e) {
  //     print('Error from google_generative_ai: ${e.toString()}');
  //     return null;
  //   }
  // }
}
