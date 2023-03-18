import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/models/user_model.dart';

import 'upload_storage_view_model.dart';

abstract class BaseSettingViewModel {
  Future<UserModel> getMySettingData();
  void updateMyName(String newName);
  void updateMyBio(String newBio);
  Future<UserModel> getContactSettingData(String contactUid);
  void updateMyProfilePic (File profileImage) ;
  
}

class SettingViewModel implements BaseSettingViewModel {
  
  FirebaseFirestore fireStore;
  FirebaseAuth auth;
  BaseUploadStorageViewModel uploadStorageViewModel ;

  SettingViewModel(this.fireStore, this.auth , this.uploadStorageViewModel);

  @override
  Future<UserModel> getMySettingData() async {
    var result =
        await fireStore.collection('users').doc(auth.currentUser!.uid).get();
    return UserModel.fromJson(result.data()!);
  }

  @override
  Future<UserModel> getContactSettingData(String contactUid) async {
    var result = await fireStore.collection('users').doc(contactUid).get();
    return UserModel.fromJson(result.data()!);
  }

  @override
  void updateMyName(String newName) {
    fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': newName});
  }
  
  @override
  void updateMyProfilePic(File profileImage) async {
     String? path = await uploadStorageViewModel.storeFileToFireStorage(
      imagePath: 'profilePic/${auth.currentUser!.uid}', file: profileImage );

      if ( path!.isEmpty ) {
          return ;
      }

      await fireStore.collection('users').doc(auth.currentUser!.uid).update({
             'profileImage' : path 
      });
  }



 void updateMyBio(String newBio) {
    fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'bio': newBio});
  }

}
