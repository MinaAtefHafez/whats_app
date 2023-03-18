import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view/screens/home_screen.dart';
import 'package:whats_app/view/screens/otp_screen.dart';
import 'package:whats_app/view/screens/user_information_screen.dart';

abstract class BaseAuthViewModel {
  void signInWithPhone({required String phoneNumber});
  void verifyOtp({required String verificationId, required String smsCode});
  Future<void> saveUserDataToFireStore(
      {required String name, required String uId, String photoUrl});
  
}

class AuthViewModel implements BaseAuthViewModel {
  FirebaseAuth auth;
  FirebaseFirestore fireStore;
  FirebaseMessaging firebaseMessaging ;

  AuthViewModel(this.auth, this.fireStore , this.firebaseMessaging );

  @override
  void signInWithPhone({
    required String phoneNumber,
  }) async 
  {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (exception) {
            showSnackBar(title: 'AuthError', message: exception.message!);
          },
          codeSent: (String verificationId, int? resendToken) {
            Get.to(() => OtpScreen(
                  verificationId: verificationId,
                ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(title: 'AuthError', message: e.message!);
    } catch (e) {
      showSnackBar(title: 'Error', message: 'error ocurred , try later !');
    }
  }

  @override
  void verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async
   {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      bool isVerify = true;
      await GetStorage().write('isVerify', isVerify);
      Get.off(() => UserInformationScreen());
    } on FirebaseAuthException catch (exception) {
          showSnackBar(title: 'Error', message: exception.message! );
    } catch (e) {
      showSnackBar(title: 'Error', message: 'error ocurred , try later !');
    }
  }

  @override
  Future<void> saveUserDataToFireStore(
      {required String name, required String uId, String? photoUrl}) async 
      {
    try {
      
         
     String? fcmToken = await firebaseMessaging.getToken();

      UserModel userModel = UserModel(
          name: name,
          uId: uId,
          profileImage: photoUrl ?? AppConstants.defaultUserImageUrl,
          phoneNumber: auth.currentUser!.phoneNumber!,
          isOnline: true,
          groupId: [] ,
           fcmToken: fcmToken ?? '' ,
          );

      await fireStore.collection('users').doc(uId).set(userModel.toMap());
      bool isAuthEnd = true;
      await GetStorage().write('isAuthEnd', isAuthEnd);
      Get.off(() => HomeScreen());
    } on FirebaseException catch (exception) {
      showSnackBar(title: 'Error', message: exception.message!);
    } catch (e) {
      showSnackBar(title: 'Error', message: 'error ocurred , try later !');
    }
  }


}
