import 'dart:io';
import 'package:aigeminiapp/model/chat_user_model.dart';
import 'package:aigeminiapp/services/gemini_flutter_service.dart';
import 'package:aigeminiapp/services/gemini_google_service.dart';
// import 'package:aigeminiapp/widgets/prompt_elevated_button.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GeminiAiHomePage extends StatefulWidget {
  const GeminiAiHomePage({super.key});

  @override
  State<GeminiAiHomePage> createState() => _GeminiAiHomePageState();
}

class _GeminiAiHomePageState extends State<GeminiAiHomePage> {
  final TextEditingController _textController = TextEditingController();
  // final TextEditingController _textGeminiController = TextEditingController();
  late ImagePicker imagePicker;

  String results = "";

  bool selectedImage = false;
  late File imageSelected;

  late GeminiGoogleService googleGemini;

  final GeminiFlutterService _geminiFlutterService = GeminiFlutterService();
  final ChatUserModel chatUserModel = ChatUserModel();

  @override
  void initState() {
    super.initState();
    googleGemini = GeminiGoogleService();
    imagePicker = ImagePicker();
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
      selectedImage = false;
      try {
        String? response =
            await googleGemini.getResponseWithImage(userInput, imageSelected);

        results = response ?? 'No response received';
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
        print('Streaming done');
      });
    }
  }

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
            _promtOutputText(),
            const SizedBox(
              height: 12,
            ),
            // _buildSearch(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter the question?',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _pickImage();
                        },
                        icon: Icon(Icons.image),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    processWithGoogleGemini();
                    // processWithFlutterGemini();
                  },
                  label: Icon(Icons.send),
                )
              ],
            ),
          ],
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
