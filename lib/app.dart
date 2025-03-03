import 'package:aigeminiapp/Pages/gemini_ai_home_page.dart';
import 'package:flutter/material.dart';

class GeminiAiApp extends StatelessWidget {
  const GeminiAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GeminiAiHomePage(),
    );
  }
}
