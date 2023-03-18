
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/status_model.dart';
import 'package:whats_app/models/who_seen_story_model.dart';
import 'package:whats_app/view/screens/confirm_status_screen.dart';
import 'package:whats_app/view/screens/status_contacts_screen.dart';
import 'package:whats_app/view_models/status_view_model.dart';

class StatusController extends GetxController {

    BaseStatusViewModel statusViewModel ;
  StatusController({
    required this.statusViewModel,
  });


  File? imageFile;
  File? videoFile;
  LoadState upLoadStatusState = LoadState.stable ; 
  int statusesIndex = 0;
  bool isFirstIndex = false ;
 

  Future<void> pickedImage() async 
  {
    var result = await ImagePicker().pickImage(source: ImageSource.gallery); 
    if (result != null) {
      imageFile = File(result.path);
      Get.to( () => ConfirmStatusScreen(file: imageFile!, fileType: 'image' , ) );
      videoFile = null ;
    }
  }

  Future<void> pickedVideo() async 
  {
    var result = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (result != null) {
      videoFile = File(result.path);
      Get.to( () => ConfirmStatusScreen(file: videoFile! ,  fileType: 'video' , ) );
      imageFile = null ;
    }
  }

  void addStatus ({
    required String text ,
  }) 
  async 
  {
    Get.off(StatusContactsScreen());
    upLoadStatusState = LoadState.loading ;
    update();
    await Future.delayed(const Duration(seconds: 3 ));
   if ( imageFile != null || videoFile != null ) {
    statusViewModel.upLoadStatus(
      text: text ,
    file: imageFile != null ? imageFile! : videoFile! ,
    fileType: imageFile != null ? 'image' : 'video' 
   );

   imageFile = null ;
   videoFile = null ;
    upLoadStatusState = LoadState.loaded ;
    update();
    
   }
   update();
  
  }
  
  
  void addTextStatus ({
    required String text
  }) async 
  {
        Get.off(StatusContactsScreen());
    upLoadStatusState = LoadState.loading ;
    update();
    await Future.delayed(const Duration(seconds: 3 ));
    statusViewModel.upLoadTextStatus(text: text);
    upLoadStatusState = LoadState.loaded ;
    update();
  }

   Future <List<StatusModel>> getMyStatuses () {
    return statusViewModel.getMyStatuses();
   }
  
  Future <List<List<StatusModel>>> getStatuses () async {
     return statusViewModel.getStatuses();
  }


  Future <void> changeStorySeen ({
    required String receiverId ,
    required String statusId
  }) {
        return statusViewModel.changeStorySeen(receiverId: receiverId ,
         statusId: statusId  
        );
  }


  Future <void> setStorySeen ({
    required String receiverId ,
    required String statusId, 
  }) {
    return statusViewModel.setStorySeen(receiverId: receiverId, statusId: statusId);
  }


  Future <List<WhoSeenStoryModel>> getWhoSeenStory ({
    required String receiverId ,
    required String statusId
  }) {
      return statusViewModel.getWhoSeenStory(receiverId: receiverId, statusId: statusId);
  }


}
