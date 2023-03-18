import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';

abstract class BaseUploadStorageViewModel {
  Future<String?> storeFileToFireStorage(
      {required String imagePath, required File file});
}

class UploadStorageViewModel implements BaseUploadStorageViewModel {
  @override
  Future<String?> storeFileToFireStorage(
      {required String imagePath, required File file}) async {
    String? downloadUrl;

    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(imagePath).putFile(file);
      TaskSnapshot snap = await uploadTask;
      downloadUrl = await snap.ref.getDownloadURL();
    } catch (e) {
      showSnackBar(title: '', message: e.toString());
    }

    return downloadUrl;
  }
}
