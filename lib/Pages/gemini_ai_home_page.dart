import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiAiHomePage extends StatefulWidget {
  const GeminiAiHomePage({super.key});

  @override
  State<GeminiAiHomePage> createState() => _GeminiAiHomePageState();
}

class _GeminiAiHomePageState extends State<GeminiAiHomePage> {
  final TextEditingController _textController = TextEditingController();

  String results = "";

  processsInput() {
    Gemini.instance.prompt(parts: [
      Part.text(_textController.text),
    ]).then((value) {
      print(value?.output);
      results = value!.output!;
      setState(() {});
    }).catchError(
      (e) {
        print('error $e');
      },
    );
  }

  // Todo: Results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(results),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                  ),
                ),
                InkWell(
                  child: Icon(Icons.send),
                  onTap: () {
                    processsInput();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
