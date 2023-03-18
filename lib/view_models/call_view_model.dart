



import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:whats_app/models/call_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view/screens/call_screen.dart';

abstract class BaseCallViewModel {
  void makeCall ({
    required CallModel senderCallModel ,
    required CallModel receiverCallModel ,
  }) ;

  void endCall ({
    required String receiverId
  }) ;

  

   

  Stream <CallModel> get callStream ;
}


   

class CallViewModel implements BaseCallViewModel {
  FirebaseFirestore fireStore ;
   FirebaseAuth auth ;
  
  CallViewModel({
   required this.fireStore,
   required this.auth,
  });
  
  @override
  void makeCall({required CallModel senderCallModel, required CallModel receiverCallModel}) async {
            try {
               
                    await fireStore.collection('calls').doc(senderCallModel.callerId).set(senderCallModel.toMap());
                    await fireStore.collection('calls').doc(senderCallModel.receiverId).set(receiverCallModel.toMap());
                     Get.to( () => CallScreen(isGroup: false , callModel: senderCallModel,));
                    
            } on SocketException {
              showSnackBar(title: '', message: 'check your internet connection') ;
            } catch (e) {
              showSnackBar(title: 'Error', message: e.toString() ); 
            }
   }
      
     @override
     Stream<CallModel> get callStream {
             return fireStore.collection('calls').doc(auth.currentUser!.uid).snapshots().map((event) {
                  return CallModel.fromJson(event.data()!);
             });
     }
     
       @override
       void endCall({
        required String receiverId
       }) async 
       {
         await fireStore.collection('calls').doc(auth.currentUser!.uid).delete();
         await fireStore.collection('calls').doc(receiverId).delete();
       }
                  
      
 }
