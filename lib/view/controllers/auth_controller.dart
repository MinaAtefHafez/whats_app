import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view_models/auth_view_model.dart';
import 'package:whats_app/view_models/upload_storage_view_model.dart';

class AuthController extends GetxController {
  Country? country;
  LoadState signInState = LoadState.stable;
  LoadState verifyOtpState = LoadState.stable;
  LoadState saveDataFireStoreState = LoadState.stable;
  File? profileImage;
  UserModel? userModel;
  BaseAuthViewModel authViewModel;
  BaseUploadStorageViewModel uploadStorageViewModel;
  AuthController(this.authViewModel, this.uploadStorageViewModel);


 

  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country c) {
        country = c;
        update();
      },
    );
  }

  void signInWithPhone({required String phoneNumber}) async {
    signInState = LoadState.loading;
    update();
    authViewModel.signInWithPhone(phoneNumber: phoneNumber);
    await Future.delayed(const Duration(seconds: 2));
    signInState = LoadState.loaded;
    update();
  }

  void verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    verifyOtpState = LoadState.loading;
    update();
    authViewModel.verifyOtp(verificationId: verificationId, smsCode: smsCode);
    await Future.delayed(const Duration(seconds: 2));
    verifyOtpState = LoadState.loaded;
    update();
  }

  void pickImageFromGallery() async {
    try {
      var pick = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pick != null) {
        profileImage = File(pick.path);
      }
    } catch (e) {
      showSnackBar(title: 'Pick Error', message: e.toString());
    }
    update();
  }

  void saveUserDateToFirebase({required String name}) async {
    saveDataFireStoreState = LoadState.loading;
    update();
    String? imageUrl;
    String uId = FirebaseAuth.instance.currentUser!.uid;
    if (profileImage != null) {
      imageUrl = await uploadStorageViewModel.storeFileToFireStorage(
          imagePath: 'profilePic/$uId', file: profileImage!);
    }
    await authViewModel.saveUserDataToFireStore(
        name: name, uId: uId, photoUrl: imageUrl!);
    saveDataFireStoreState = LoadState.loaded;
    update();
  }

  
}
