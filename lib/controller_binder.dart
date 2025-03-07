import 'package:aigeminiapp/controller/pick_image_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(PickImageController());
  }
}
