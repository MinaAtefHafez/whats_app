
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view_models/setting_view_model.dart';


class SettingController extends GetxController {

  
  BaseSettingViewModel settingViewModel;
  

  SettingController(this.settingViewModel);

  File? settingImage ;


  Future <UserModel> getMySettingData () {
   return settingViewModel.getMySettingData();
  }

    

  void pickSettingImage () async {
      var pick = await ImagePicker().pickImage(source: ImageSource.gallery );
      settingImage = File(pick!.path);
      updateMyProfilePic();
      update();
  }

  void updateMyName (String newName) {
    settingViewModel.updateMyName(newName);
  }


  void updateMyProfilePic () {
    settingViewModel.updateMyProfilePic(settingImage!);
  }

  void updateMyBio (String newBio) {
    settingViewModel.updateMyBio(newBio);
  }
  

}