import 'package:aigeminiapp/Pages/ai_home_page.dart';
import 'package:flutter/material.dart';

class AiApp extends StatelessWidget {
  const AiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: _appBarStyleTheme(),
        inputDecorationTheme: _inputStyleDecorationTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      // initialBinding: ControllerBinder(),
      home: const AiHomePage(),
    );
  }

  InputDecorationTheme _inputStyleDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
    );
  }

  AppBarTheme _appBarStyleTheme() {
    return AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
