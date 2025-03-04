import 'package:dash_chat_2/dash_chat_2.dart';

class ChatUserModel {
  static ChatUser user = ChatUser(
    id: '1',
    firstName: 'Rtl',
    lastName: 'Islam',
  );

  static ChatUser geminiUser = ChatUser(
    id: '2',
    firstName: 'Gemini',
    lastName: 'AI',
  );
  List<ChatMessage> messages = <ChatMessage>[];
}
