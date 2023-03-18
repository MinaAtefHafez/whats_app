



import 'package:get/get.dart';
import 'package:whats_app/core/service_locator/service_locator.dart';
import 'package:whats_app/view/controllers/auth_controller.dart';
import 'package:whats_app/view/controllers/call_controller.dart';
import 'package:whats_app/view/controllers/chat_controller.dart';
import 'package:whats_app/view/controllers/group_controller.dart';
import 'package:whats_app/view/controllers/home_controller.dart';
import 'package:whats_app/view/controllers/setting_controller.dart';
import 'package:whats_app/view/controllers/status_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(serviceLocator() , serviceLocator() ));
    Get.put<HomeController>(HomeController(serviceLocator()));
    Get.put<ChatController>(ChatController(serviceLocator() , serviceLocator() ));
    Get.put<StatusController>(StatusController(statusViewModel: serviceLocator()));
    Get.put<GroupController>(GroupController(homeViewModel: serviceLocator() , groupViewModel: serviceLocator()  ));
    Get.put<CallController>(CallController(serviceLocator() , serviceLocator() , serviceLocator()));
    Get.put<SettingController>(SettingController(serviceLocator()));
  }

}