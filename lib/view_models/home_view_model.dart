// ignore_for_file: body_might_complete_normally_nullable, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whats_app/models/last_message_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';

abstract class BaseHomeViewModel {
  Future<List<Contact>> getContacts();
  Future<UserModel?> selectContactToChat({required Contact selectContact});
  Stream<List<LastMessageModel>> showAllChatContacts();
}

class HomeViewModel implements BaseHomeViewModel {
  FirebaseFirestore fireStore;
  FirebaseAuth auth;

  HomeViewModel(this.fireStore, this.auth);

  @override
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      showSnackBar(title: 'Error', message: e.toString());
    }
    return contacts;
  }

  @override
  Future<UserModel?> selectContactToChat(
      {required Contact selectContact}) async 
      {
    UserModel? userModel;
    String? phoneNumber;
    String firstChar = selectContact.phones[0].number.split('')[0];

    try {
      if (firstChar == '+') {
        phoneNumber = selectContact.phones[0].number.replaceAll(' ', '');
      } else {
        phoneNumber = '+2${selectContact.phones[0].number.replaceAll(' ', '')}';
      }
      var result = await fireStore.collection('users').get();

      for (int i = 0; i < result.docs.length; i++) {
        if (phoneNumber == result.docs[i].data()['phoneNumber']) {
          userModel = UserModel.fromJson(result.docs[i].data());
        }
      }
    } catch (e) {
      showSnackBar(title: 'select Number Error', message: e.toString());
    }

    return userModel;
  }

  @override
  Stream<List<LastMessageModel>> showAllChatContacts()
   {
  
      return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats').orderBy('dateTime' , descending: true  )
        .snapshots()
        .map((event) {
           List <LastMessageModel> contacts = [];
      for (int  i = 0  ; i < event.docs.length ; i++ ) {
        contacts.add(LastMessageModel.fromJson(event.docs[i].data()));
      }
      return contacts;
    });
  }
}
