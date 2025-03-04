import 'package:aigeminiapp/app.dart';
import 'package:aigeminiapp/secret_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: SecretKey.apiKey); //add the api key
  runApp(const GeminiAiApp());
}
