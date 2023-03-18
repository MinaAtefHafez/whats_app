// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/models/react_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view_models/chat_view_model.dart';
import 'package:whats_app/view_models/upload_storage_view_model.dart';

class ChatController extends GetxController {
  ChatController(this.chatViewModel, this.uploadStorageViewModel);
  BaseChatViewModel chatViewModel;
  BaseUploadStorageViewModel uploadStorageViewModel;
  ScrollController messagesController = ScrollController();
  File? imageFile;
  File? videoFile;
  File? audioFile;
  LoadState sendMessageState = LoadState.stable;
  List<String> reactsList = ['👍', '❤️', '😂', '😯', '😥', '🙏'];

  Future<void> pickedImage() async {
    var result = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result != null) {
      videoFile = null;
      audioFile = null;
      imageFile = File(result.path);
    }
  }

  Future<void> pickedVideo() async {
    var result = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (result != null) {
      imageFile = null;
      audioFile = null;
      videoFile = File(result.path);
    }
  }


 Future <String> getMyProfilePic () async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    UserModel userModel = UserModel.fromJson(userData.data()!);
    return userModel.profileImage! ;
  }
 
  Future <String> getMyName () async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    UserModel userModel = UserModel.fromJson(userData.data()!);
    return userModel.name! ;
  }


  Future<void> sendTextMessage({
    required String text,
    required String contactId,
    required MessageModel swipeModel,
    required bool isReplied,
  }) async 
  {
    sendMessageState = LoadState.loading;
    update();
    var auth = FirebaseAuth.instance;
    String fileUrl = '';
    String messageId = const Uuid().v1();
    
   
   

    MessageModel messageModel = MessageModel(
          text: text  ,
          type: 'text',
          senderId: auth.currentUser!.uid,
          receiverId: contactId,
          profilePic: '' ,
          time: DateFormat.jm().format(DateTime.now()),
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMMMMd().format(DateTime.now()).toString(),
          fileUrl: fileUrl ,
          isSeen: false, 
          repliedText: isReplied ? swipeModel.text! : ''  ,
          repliedType: isReplied ? swipeModel.type! : '' ,
          repliedFileUrl: isReplied ? swipeModel.fileUrl! : '' ,
          messageId: messageId  ,
          contactName: isReplied ? swipeModel.senderName! : '' ,
          senderName: await getMyName() ,
          repliedId: isReplied ? swipeModel.senderId! : '' ,
          isDeleted: false 
          ); 



    await chatViewModel.saveLastMessageData(
      lastMessage: text,
      contactId: contactId,
      messageType: 'text',
    );

    await chatViewModel.sendMessage(
        messageModel: messageModel
        );
    sendMessageState = LoadState.loaded;
    update();
  }


    Future<void> sendImageMessage({
     String? text,
    required String contactId,
    required MessageModel swipeModel,
    required bool isReplied,
  }) async 
  {
    sendMessageState = LoadState.loading;
    update();
    var auth = FirebaseAuth.instance;
    String fileUrl = '';
    String messageId = const Uuid().v1();
    
   
   
     fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/image/${auth.currentUser!.uid}/$contactId/$messageId',
          file: imageFile!))!;

        imageFile = null ;
    MessageModel messageModel = MessageModel(
          text: text ?? '' ,
          type: 'image',
          senderId: auth.currentUser!.uid,
          receiverId: contactId,
          profilePic: '' ,
          time: DateFormat.jm().format(DateTime.now()),
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMMMMd().format(DateTime.now()).toString(),
          fileUrl: fileUrl ,
          isSeen: false, 
          repliedText: isReplied ? swipeModel.text! : ''  ,
          repliedType: isReplied ? swipeModel.type! : '' ,
          repliedFileUrl: isReplied ? swipeModel.fileUrl! : '' ,
          messageId: messageId  ,
          contactName: isReplied ? swipeModel.senderName! : '' ,
          senderName: await getMyName() ,
          repliedId: isReplied ? swipeModel.senderId! : '' ,
          isDeleted: false 
          ); 



    await chatViewModel.saveLastMessageData(
      lastMessage: text ?? '',
      contactId: contactId,
      messageType: 'image',
    );

    await chatViewModel.sendMessage(
        messageModel: messageModel
        );
    sendMessageState = LoadState.loaded;
    update();
  }


  Future<void> sendVideoMessage({
     String? text,
    required String contactId,
    required MessageModel swipeModel,
    required bool isReplied,
  }) async 
  {
    sendMessageState = LoadState.loading;
    update();
    var auth = FirebaseAuth.instance;
    String fileUrl = '';
    String messageId = const Uuid().v1();
    
   
   
     fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/video/${auth.currentUser!.uid}/$contactId/$messageId',
          file: videoFile!))!;

          videoFile = null ;

    MessageModel messageModel = MessageModel(
          text: text ?? '' ,
          type: 'video',
          senderId: auth.currentUser!.uid,
          receiverId: contactId,
          profilePic: '' ,
          time: DateFormat.jm().format(DateTime.now()),
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMMMMd().format(DateTime.now()).toString(),
          fileUrl: fileUrl ,
          isSeen: false, 
          repliedText: isReplied ? swipeModel.text! : ''  ,
          repliedType: isReplied ? swipeModel.type! : '' ,
          repliedFileUrl: isReplied ? swipeModel.fileUrl! : '' ,
          messageId: messageId  ,
          contactName: isReplied ? swipeModel.senderName! : '' ,
          senderName: await getMyName() ,
          repliedId: isReplied ? swipeModel.senderId! : '' ,
          isDeleted: false 
          ); 



    await chatViewModel.saveLastMessageData(
      lastMessage: text ??'',
      contactId: contactId,
      messageType: 'video',
    );

    await chatViewModel.sendMessage(
        messageModel: messageModel
        );
    sendMessageState = LoadState.loaded;
    update();
  }


   Future<void> sendAudioMessage({
     String? text,
    required String contactId,
    required MessageModel swipeModel,
    required bool isReplied,
  }) async 
  {
    sendMessageState = LoadState.loading;
    update();
    var auth = FirebaseAuth.instance;
    String fileUrl = '';
    String messageId = const Uuid().v1();
    
   
   
     fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/audio/${auth.currentUser!.uid}/$contactId/$messageId',
          file: audioFile!))!;

          audioFile = null ;

    MessageModel messageModel = MessageModel(
          text: text ?? '' ,
          type: 'audio',
          senderId: auth.currentUser!.uid,
          receiverId: contactId,
          profilePic: '' ,
          time: DateFormat.jm().format(DateTime.now()),
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMMMMd().format(DateTime.now()).toString(),
          fileUrl: fileUrl ,
          isSeen: false, 
          repliedText: isReplied ? swipeModel.text! : ''  ,
          repliedType: isReplied ? swipeModel.type! : '' ,
          repliedFileUrl: isReplied ? swipeModel.fileUrl! : '' ,
          messageId: messageId  ,
          contactName: isReplied ? swipeModel.senderName! : '' ,
          senderName: await getMyName() ,
          repliedId: isReplied ? swipeModel.senderId! : '' ,
          isDeleted: false 
          ); 



    await chatViewModel.saveLastMessageData(
      lastMessage: text ?? '',
      contactId: contactId,
      messageType: 'audio',
    );

    await chatViewModel.sendMessage(
        messageModel: messageModel
        );
    sendMessageState = LoadState.loaded;
    update();
  }


  Stream<UserModel> isOnlineOrNot({required String uId}) {
    return chatViewModel.isOnlineOrNot(uId: uId);
  }

  Stream<List<MessageModel>> getMessages({required String contactId}) {
    return chatViewModel.getMessages(contactId: contactId);
  }

  void sendReact(
      {required int reactType,
      required String receiverId,
      required String messageId
      })  
      {
     chatViewModel.sendReact(
        reactType: reactType, receiverId: receiverId, messageId: messageId);

  }
  

  Stream <List<ReactModel>> getReacts ({
    required String receiverId ,
    required String messageId ,
  }) 
  {
      return chatViewModel.getReacts(receiverId: receiverId, messageId: messageId);
  }


  void deleteMessage ({
    required bool isDeleteForEveryOne ,
    required String receiverId ,
    required String messageId
  }) 
  {
    chatViewModel.deleteMessage(
      isDeleteForEveryOne: isDeleteForEveryOne , 
      receiverId: receiverId,
       messageId: messageId
       );
  }

  
  void setSeen ({
    required String receiverId ,
    required String messageId,
  }) 
  {
    chatViewModel.setSeen(receiverId: receiverId, messageId: messageId);
    
  }

    // group Chat methods

   Future <void> sendGroupMessage ({
    required String text,
    required MessageModel swipeModel,
    required bool isReplied,
    required String groupId
  }) async 
  {
    sendMessageState = LoadState.loading;
    update();
    var auth = FirebaseAuth.instance;
    String fileUrl = '';
    String messageId = const Uuid().v1();
    String messageType = '';
   
   
    if (imageFile != null) {
      
      messageType = 'image';

      fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/image/${auth.currentUser!.uid}/$groupId/$messageId',
          file: imageFile!))!;

      imageFile = null;
    } else if (videoFile != null) {
      
      messageType = 'video';
      fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/video/${auth.currentUser!.uid}/$groupId/$messageId',
          file: videoFile!))!;
      videoFile = null;
    } else if (audioFile != null) {
      
      messageType = 'audio';

      fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(
          imagePath:
              'chat/audio/${auth.currentUser!.uid}/$groupId/$messageId',
          file: audioFile!))!;

      audioFile = null;
    } else {
      messageType = 'text';
    }
       
       chatViewModel.sendGroupMessage(
        text: text,
        receiverId: '' ,
         receiverName: isReplied ? swipeModel.senderName! : '' , 
         senderName: await getMyName(),
         profilePic: await getMyProfilePic(),
          messageType: messageType,
           fileUrl: fileUrl, 
           repliedText: isReplied ? swipeModel.text! : '',
            repliedType: isReplied ? swipeModel.type! : '', 
            repliedFileUrl: isReplied ? swipeModel.fileUrl! : '',
             messageId: messageId, 
              repliedId: isReplied ? swipeModel.senderId! : '' , 
               groupId: groupId ,
               );

    sendMessageState = LoadState.loaded;
    update();
     
    }
 
  void sendGroupReact(
      {required int reactType,
      required String groupId,
      required String messageId
      })  
      {
     chatViewModel.sendGroupReact(
        reactType: reactType, groupId: groupId, messageId: messageId);

  }

   Stream <List<ReactModel>> getGroupReacts ({
    required String groupId ,
    required String messageId ,
  }) 
  {
      return chatViewModel.getGroupReacts(groupId: groupId, messageId: messageId);
  }

    Stream<List<MessageModel>> getGroupMessages({required String groupId}) {
    return chatViewModel.getGroupMessages(groupId: groupId);
  }

  void deleteGroupMessage ({
    required String messageId ,
    required String groupId
  })
   {
      chatViewModel.deleteGroupMessage(messageId: messageId, groupId: groupId);
  }


  void changeMessagesThatNotSeenCount ({
    required String contactId
  }) 
  {
      chatViewModel.changeMessagesThatNotSeenCount(contactId: contactId);
  }

  void sendTextMessageNotification ({
    required List<String> fcmTokens ,
    required String notificationBody ,
  }) {
      chatViewModel.sendTextNotification(fcmTokens: fcmTokens, notificationBody: notificationBody);
  }

  void sendImageMessageNotification ({
    required List<String> fcmTokens ,
  }) {
      chatViewModel.sendImageNotification(fcmTokens: fcmTokens);
  }

  void sendVideoMessageNotification ({
    required List<String> fcmTokens ,
  }) {
      chatViewModel.sendVideoNotification(fcmTokens: fcmTokens);
  }


  void sendAudioMessageNotification ({
    required List<String> fcmTokens ,
  }) {
      chatViewModel.sendAudioNotification(fcmTokens: fcmTokens);
  }


  void sendTextMessageNotificationToGroup ({

    required String notificationBody ,
    required List<String> membersUid
  }) {
      chatViewModel.sendTextNotificationToGroup( notificationBody: notificationBody , membersUid: membersUid );
  }

  void sendImageMessageNotificationToGroup ({
    required List<String> membersUid
  }) {
      chatViewModel.sendImageNotificationToGroup( membersUid: membersUid );
  }


  void sendVideoMessageNotificationToGroup ({
    required List<String> membersUid
  }) {
      chatViewModel.sendVideoNotificationToGroup( membersUid: membersUid );
  }


  void sendAudioMessageNotificationToGroup ({
    required List<String> membersUid
  }) {
      chatViewModel.sendAudioNotificationToGroup( membersUid: membersUid );
  }

}
