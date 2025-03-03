import 'package:aigeminiapp/services/gemini_flutter_service.dart';
import 'package:aigeminiapp/services/gemini_google_service.dart';
import 'package:aigeminiapp/widgets/prompt_elevated_button.dart';
import 'package:flutter/material.dart';

class GeminiAiHomePage extends StatefulWidget {
  const GeminiAiHomePage({super.key});

  @override
  State<GeminiAiHomePage> createState() => _GeminiAiHomePageState();
}

class _GeminiAiHomePageState extends State<GeminiAiHomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textGeminiController = TextEditingController();

  String results = "";

  late GeminiGoogleService googleGemini;

  final GeminiFlutterService _geminiFlutterService = GeminiFlutterService();

  @override
  void initState() {
    super.initState();
    googleGemini = GeminiGoogleService();
  }

  void processWithFlutterGemini() async {
    String? response =
        await _geminiFlutterService.getResponse(_textController.text);
    results = response ?? 'No response';
    _textController.clear();
    setState(() {});
  }

  void processWithGoogleGemini() async {
    String? response =
        await googleGemini.getResponse(_textGeminiController.text);

    results = response ?? 'No response received';
    _textGeminiController.clear();
    setState(() {});
  }

  // Todo: Results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Gemini App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    results,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your query with Google Gemini: ',
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  controller: _textGeminiController,
                ),
                const SizedBox(
                  height: 5,
                ),
                PromptElevatedButton(
                    label: " Send to Google Gemini",
                    onPressed: processWithGoogleGemini),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your query with Flutter Gemini: ',
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  controller: _textController,
                ),
                const SizedBox(
                  height: 5,
                ),
                PromptElevatedButton(
                    label: " Send to Flutter Gemini",
                    onPressed: processWithFlutterGemini),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
