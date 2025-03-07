import 'dart:io';
import 'package:aigeminiapp/model/chat_user_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageController extends GetxController {
  ChatUserModel chatUserModel = ChatUserModel();
  late ImagePicker _imagePicker;
  bool _selectedImage = false;
  late File _imageSelected;
  File get imageSelected => _imageSelected;
  bool get selectedImage => _selectedImage;

  ImagePicker get imagePicked => _imagePicker;

  @override
  void onInit() {
    super.onInit();
    _imagePicker = ImagePicker();
  }

  Future<void> getPickedImageChat() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _selectedImage = true;
      _imageSelected = File(image.path);
      ChatMessage chatMessage = ChatMessage(
        user: ChatUserModel.user,
        createdAt: DateTime.now(),
        text: '',
        medias: [
          ChatMedia(
            url: image.path,
            fileName: image.name,
            type: MediaType.image,
          ),
        ],
      );
      chatUserModel.messages.insert(0, chatMessage);
      update();
    }
  }
}
