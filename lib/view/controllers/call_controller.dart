







import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/models/call_model.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/user_model.dart';

import 'package:whats_app/view_models/call_view_model.dart';

class CallController extends GetxController {

  BaseCallViewModel callViewModel ;
  FirebaseFirestore firestore ;
  FirebaseAuth auth ;
  CallController(
    this.callViewModel,
    this.firestore ,
    this.auth
  );

  Future <UserModel> getCurrentUserData () async 
  {
      var result = await firestore.collection('users').doc(auth.currentUser!.uid).get();
       return UserModel.fromJson(result.data()!);
   }

  void makeCall ({
    required UserModel userModel, 
    required GroupModel groupModel
  }) async 
  {
         
         String callerId = const Uuid().v1();
          UserModel currentUserModel = await getCurrentUserData(); 
         CallModel senderCallModel = CallModel(
          callerId: currentUserModel.uId!, 
          callerName: currentUserModel.name!, 
          callerPic: currentUserModel.profileImage! ,
           receiverId: userModel.uId!,
            receiverName: userModel.name!,
             receiverPic: userModel.profileImage! , 
             callId: callerId ,
             hasDialled: true 
             );


             CallModel receiverCallModel = CallModel(
          callerId: currentUserModel.uId!, 
          callerName: currentUserModel.name!, 
          callerPic: currentUserModel.profileImage! ,
           receiverId: userModel.uId!,
            receiverName: userModel.name!,
             receiverPic: userModel.profileImage! , 
             callId: callerId ,
             hasDialled: false 
             );
      
      callViewModel.makeCall(
        senderCallModel: senderCallModel , 
        receiverCallModel: receiverCallModel ,
        );
  }
  
  void endCall ({
    required String receiverId
  }) {
     callViewModel.endCall(receiverId: receiverId);
  }

  

  Stream <CallModel> get callStream  {
    return callViewModel.callStream ;
  }


  
}
