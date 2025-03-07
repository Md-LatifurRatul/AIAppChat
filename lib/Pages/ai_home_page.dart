import 'dart:io';
import 'package:aigeminiapp/model/chat_user_model.dart';
import 'package:aigeminiapp/services/gemini_flutter_service.dart';
import 'package:aigeminiapp/services/gemini_google_service.dart';
import 'package:aigeminiapp/widgets/submit_elevated_button.dart';
// import 'package:aigeminiapp/widgets/prompt_elevated_button.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiHomePage extends StatefulWidget {
  const AiHomePage({super.key});

  @override
  State<AiHomePage> createState() => _AiHomePageState();
}

class _AiHomePageState extends State<AiHomePage> {
  final TextEditingController _textController = TextEditingController();
  // final TextEditingController _textGeminiController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SpeechToText _speechToText = SpeechToText();

  FlutterTts flutterTts = FlutterTts();

  bool speechEnabled = false;
  String _lastWords = '';
  late ImagePicker imagePicker;

  String results = "";

  bool selectedImage = false;
  late File imageSelected;

  late GeminiGoogleService googleGemini;

  final GeminiFlutterService _geminiFlutterService = GeminiFlutterService();
  final ChatUserModel chatUserModel = ChatUserModel();

  bool isTTS = false;
  bool isDart = false;

  @override
  void initState() {
    super.initState();
    googleGemini = GeminiGoogleService();
    imagePicker = ImagePicker();
    _initSpeech();
    loadSpeachData();
  }

  loadSpeachData() async {
    // List<dynamic> languages = await flutterTts.getLanguages;
    // List<dynamic> voices = await flutterTts.getVoices;

    // for (var e in languages) {
    //   print("Language = $e");
    // }
    // for (var e in voices) {
    //   print("Voices = $e");
    // }
    // flutterTts.setLanguage('bn-BD');
    flutterTts.setLanguage('en-US');
    flutterTts.setVoice({"name": "en-us-x-iol-local", "locale": "en-US"});

    // flutterTts.setLanguage('ja-JP');

    // flutterTts.setLanguage('ur-PK');
  }

  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    _textController.text = _lastWords;
    if (result.finalResult) {
      setState(() {
        // _lastWords = result.recognizedWords;
        // _textController.text = _lastWords;
        processWithGoogleGemini();
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = true;
      imageSelected = File(image.path);

      ChatMessage chatMessage = ChatMessage(
          user: ChatUserModel.user,
          createdAt: DateTime.now(),
          text: '',
          medias: [
            ChatMedia(
                url: image.path, fileName: image.name, type: MediaType.image),
          ]);
      chatUserModel.messages.insert(0, chatMessage);
      setState(() {});
    }
  }

  void processWithFlutterGemini() async {
    String userInput = _textController.text;
    _textController.clear();

    ChatMessage chatMessage = ChatMessage(
        user: ChatUserModel.user, createdAt: DateTime.now(), text: userInput);
    chatUserModel.messages.insert(0, chatMessage);
    setState(() {});

    if (selectedImage) {
      selectedImage = false;

      // ChatMessage chatMessageAI = ChatMessage(
      //     user: ChatUserModel.geminiUser,
      //     createdAt: DateTime.now(),
      //     text: results);
      // chatUserModel.messages.insert(0, chatMessageAI);

      // setState(() {});
    } else {
      String? response = await _geminiFlutterService.getResponse(userInput);
      results = response ?? 'No response';

      ChatMessage chatMessageAI = ChatMessage(
          user: ChatUserModel.geminiUser,
          createdAt: DateTime.now(),
          text: results);
      chatUserModel.messages.insert(0, chatMessageAI);

      setState(() {});
    }
  }

  void processWithGoogleGemini() async {
    String userInput = _textController.text;
    _textController.clear();
    //  _textGeminiController.clear();
    // String userInput = _textGeminiController.text;
    ChatMessage chatMessage = ChatMessage(
        user: ChatUserModel.user, createdAt: DateTime.now(), text: userInput);
    chatUserModel.messages.insert(0, chatMessage);
    setState(() {});
    // String? response =
    //     await googleGemini.getResponse(userInput);

    if (selectedImage) {
      _imageChatFeature(userInput);
    } else {
      //Using Gemini Prompt model

      // String? response = await googleGemini.getResponse(userInput);
      // results = response ?? 'No response received';
      // ChatMessage chatMessageAI = ChatMessage(
      //     user: ChatUserModel.geminiUser,
      //     createdAt: DateTime.now(),
      //     text: results);
      // chatUserModel.messages.insert(0, chatMessageAI);
      // setState(() {});

      //Using Multi-chat Gemini Model chat model

      // String? response = await googleGemini.getResponseChat(userInput);

      // results = response ?? 'No response received';
      // ChatMessage chatMessageAI = ChatMessage(
      //     user: ChatUserModel.geminiUser,
      //     createdAt: DateTime.now(),
      //     text: results);
      // chatUserModel.messages.insert(0, chatMessageAI);

      // setState(() {});

      //Using Gemini Streaming content Method

      bool isFirst = true;
      results = "";

      googleGemini.generateContentStreamChat(userInput).listen((response) {
        if (isFirst) {
          isFirst = false;
        } else {
          chatUserModel.messages.removeAt(0);
        }

        if (response.text != null && response.text!.isNotEmpty) {
          results += response.text!;
          ChatMessage chatMessageAI = ChatMessage(
            user: ChatUserModel.geminiUser,
            createdAt: DateTime.now(),
            text: results,
          );

          if (chatUserModel.messages.isNotEmpty &&
              chatUserModel.messages[0].user == ChatUserModel.geminiUser) {
            chatUserModel.messages[0] = chatMessageAI;
          } else {
            chatUserModel.messages.insert(0, chatMessageAI);
          }

          setState(() {});
        }
      }, onError: (error) {
        print('Error streaming response: $error');

        ChatMessage chatMessageAI = ChatMessage(
          user: ChatUserModel.geminiUser,
          createdAt: DateTime.now(),
          text: "Error generating response.",
        );
        chatUserModel.messages.insert(0, chatMessageAI);
        setState(() {});
      }, onDone: () {
        handleDone();
        print('Streaming done');
      });
    }
  }

  Future<void> _imageChatFeature(String userInput) async {
    selectedImage = false;
    try {
      String? response =
          await googleGemini.getResponseWithImage(userInput, imageSelected);

      results = response ?? 'No response received';

      if (isTTS) {
        flutterTts.speak(results);
      }

      ChatMessage chatMessageAI = ChatMessage(
        user: ChatUserModel.geminiUser,
        createdAt: DateTime.now(),
        text: results,
      );
      chatUserModel.messages.insert(0, chatMessageAI);
      setState(() {});
    } catch (e) {
      print('Error processing image: $e');
      ChatMessage chatMessageAI = ChatMessage(
        user: ChatUserModel.geminiUser,
        createdAt: DateTime.now(),
        text: 'Error processing image.',
      );
      chatUserModel.messages.insert(0, chatMessageAI);
      setState(() {});
    }
  }

  void handleDone() {
    if (isTTS) {
      flutterTts.speak(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gemini App',
        ),
        leading: _appBarChangeModeButton(),
        actions: [
          _appBarVoiceModeButton(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
            invertColors: isDart,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _promtOutputText(),
              const SizedBox(
                height: 12,
              ),
              // _buildSearch(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _textInputField(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SubmitElevatedButton(
                      bgColor: Colors.green.shade400,
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        _startListening();
                      },
                    ),
                    SubmitElevatedButton(
                      bgColor: Colors.blue,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          processWithGoogleGemini();
                          // processWithFlutterGemini();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarVoiceModeButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (isTTS) {
            isTTS = false;
          } else {
            isTTS = true;
          }
        });
      },
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          isTTS ? Icons.surround_sound : Icons.mic_off,
          size: 30,
        ),
      ),
    );
  }

  Widget _appBarChangeModeButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (isDart) {
            isDart = false;
          } else {
            isDart = true;
          }
        });
      },
      icon: isDart ? Icon(Icons.sunny) : Icon(Icons.nightlight_round_outlined),
    );
  }

  Widget _textInputField() {
    return TextFormField(
      autofocus: true,
      style: TextStyle(
        color: Colors.black,
      ),
      onFieldSubmitted: (value) {
        processWithGoogleGemini();
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Provide Text";
        }
        return null;
      },
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Enter the question?',
        suffixIcon: IconButton(
          onPressed: () {
            _pickImage();
          },
          icon: Icon(Icons.image),
        ),
      ),
    );
  }

  Widget _promtOutputText() {
    return Expanded(
      child: DashChat(
        currentUser: ChatUserModel.user,
        onSend: (ChatMessage m) {},
        messages: chatUserModel.messages,
        readOnly: true,
      ),
    );
  }

  // Widget _buildSearch() {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       TextFormField(
  //         decoration: InputDecoration(
  //           labelText: 'Enter your query with Google Gemini: ',
  //           border: OutlineInputBorder(),
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  //         ),
  //         controller: _textGeminiController,
  //       ),
  //       const SizedBox(
  //         height: 5,
  //       ),
  //       PromptElevatedButton(
  //           label: " Send to Google Gemini",
  //           onPressed: processWithGoogleGemini),
  //       const SizedBox(
  //         height: 30,
  //       ),
  //       TextFormField(
  //         decoration: InputDecoration(
  //           labelText: 'Enter your query with Flutter Gemini: ',
  //           border: OutlineInputBorder(),
  //           contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  //         ),
  //         controller: _textController,
  //       ),
  //       const SizedBox(
  //         height: 5,
  //       ),
  //       PromptElevatedButton(
  //           label: " Send to Flutter Gemini",
  //           onPressed: processWithFlutterGemini),
  //     ],
  //   );
  // }

  // Widget _promtOutputText() {
  //   return Expanded(
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[200],
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: SingleChildScrollView(
  //         child: Text(
  //   results,
  //   style: const TextStyle(fontSize: 16),
  // ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _textController.dispose();
    // _textGeminiController.dispose();
    super.dispose();
  }
}
