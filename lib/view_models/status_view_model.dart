

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/models/status_model.dart';
import 'package:whats_app/models/who_seen_story_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view_models/upload_storage_view_model.dart';

abstract class BaseStatusViewModel {

 void upLoadStatus ({
  required File file ,
  required String fileType ,
  required String text
 });

  void upLoadTextStatus ({
    required String text
   }); 
  
  Future <List<List<StatusModel>>> getStatuses () ;

  Future <List<StatusModel>> getMyStatuses () ;

  Future <void> changeStorySeen ({
    required String receiverId ,
    required String statusId
  }) ;

  Future <void> setStorySeen ({required String receiverId ,
    required String statusId
  }) ;

  Future <List<WhoSeenStoryModel>> getWhoSeenStory ({
    required String receiverId ,
    required String statusId ,
  }) ;
  
}


class StatusViewModel implements BaseStatusViewModel { 

  FirebaseAuth auth ;
  FirebaseFirestore firestore ;
  BaseUploadStorageViewModel uploadStorageViewModel ;
  StatusViewModel({
    required this.auth ,
    required this.firestore ,
    required this.uploadStorageViewModel
  });
 
  @override
  void upLoadStatus({
    required File file ,
    required String fileType ,
    required String text
  }) async 
  {

   try {
     String statusId = const Uuid().v1();
    String uId = auth.currentUser!.uid ;
    String fileUrl = (await uploadStorageViewModel.storeFileToFireStorage(imagePath: '/status/$statusId$uId', file: file ))!;
    List <Contact> contacts = [] ;
    List <String> uidWhoCanSee = [] ;
    contacts  =  await FlutterContacts.getContacts(withProperties: true);

    var usersData = await firestore.collection('users').get();

      
    for ( int i = 0 ; i < contacts.length ; i++ ) {
      for ( int j = 0 ; j < usersData.docs.length ; j++ ) {
             String firstChar = contacts[i].phones[0].number.split('')[0] ;
             String contact ;
             var docData = usersData.docs[j].data();
             if ( firstChar == '+' ) {
                contact = contacts[i].phones[0].number.replaceAll(' ', '');
             } else {
              contact = '+2${contacts[i].phones[0].number.replaceAll(' ', '')}'; 
             }
           if ( contact == docData['phoneNumber'] ){ 
              uidWhoCanSee.add(docData['uId']);
           }
      }
    }

       var userData = await firestore.collection('users').doc(auth.currentUser!.uid).get();
        

        StatusModel statusModel = StatusModel(
          userName: userData.data()!['name'] ,
          statusId: statusId ,
          createdAt: DateTime.now().toString() ,
          time: DateFormat.jm().format(DateTime.now()), 
          uId: auth.currentUser!.uid ,
            fileUrl: fileUrl ,
            whoCanSee: uidWhoCanSee ,
            fileType: fileType ,
            text: text ,
            isStory: true , 
            isSeen: ['uid experimental'] ,
            profilePic: userData.data()!['profileImage'], 
        );

       await firestore.collection('users').doc(auth.currentUser!.uid).collection('status').doc(statusId).set(statusModel.toMap());
    
     
   } catch (e) {
        showSnackBar(title: 'error', message:  e.toString() );
        
   }
   
   
     
  }

    @override
   void upLoadTextStatus ({
    required String text
   }) async 
   {
        try {

           List <Contact> contacts = [] ;
           List <String> uidWhoCanSee = [] ;
          
          
          var usersData = await firestore.collection('users').get();
      
    for ( int i = 0 ; i < contacts.length ; i++ ) {
      for ( int j = 0 ; j < usersData.docs.length ; j++ ) {
             String firstChar = contacts[i].phones[0].number.split('')[0] ;
             String contact ;
             var docData = usersData.docs[j].data();
             if ( firstChar == '+' ) {
                contact = contacts[i].phones[0].number.replaceAll(' ', '');
             } else {
              contact = '+2${contacts[i].phones[0].number.replaceAll(' ', '')}'; 
             }
           if ( contact == docData['phoneNumber'] ){ 
              uidWhoCanSee.add(docData['uId']);
           }
      }
    }

           String statusId = const Uuid().v1();
           var userData = await firestore.collection('users').doc(auth.currentUser!.uid).get();


              StatusModel statusModel = StatusModel(
          userName: userData.data()!['name'] ,
          statusId: statusId ,
          createdAt: DateTime.now().toString() ,
          time: DateFormat.jm().format(DateTime.now()), 
          uId: auth.currentUser!.uid ,
            fileUrl: '' ,
            whoCanSee: uidWhoCanSee ,
            fileType: 'text' ,
            text: text ,
            isStory: true , 
            isSeen: ['uid experimental'] ,
            profilePic: userData.data()!['profileImage'],
        );
         await firestore.collection('users').doc(auth.currentUser!.uid).collection('status').doc(statusId).set(statusModel.toMap());
        } catch (e) {
              showSnackBar(title: 'Error', message: e.toString() );
        }
   }

   @override
  Future <List<StatusModel>> getMyStatuses () async 
  {
     List <StatusModel> statusesList = [] ;
      var data = await firestore.collection('users').doc(auth.currentUser!.uid).collection('status').orderBy('createdAt')
          .where( 'createdAt' , isGreaterThan: DateTime.now().subtract(const Duration( hours: 24 )).toString()).get();
             
             for (int i = 0 ; i < data.docs.length ; i++ ) {
                 statusesList.add(StatusModel.fromJson(data.docs[i].data()));
             }
             return statusesList ;
         
  }

  
  @override
  Future <List<List<StatusModel>>> getStatuses() async 
  { 

    List<StatusModel>userStatuses = [] ;
    List <List<StatusModel>> statuses = [];
    
     var data = await firestore.collection('users').get();
     for ( int i = 0 ; i < data.docs.length ; i++ ) {
       var statusesUserData = await data.docs[i].reference.
       collection('status').orderBy('createdAt').
       where( 'createdAt' , isGreaterThan: DateTime.now().subtract(const Duration( hours: 24 )).toString()).get();
       userStatuses = [];
           for ( int j = 0 ; j < statusesUserData.docs.length ; j++ ) {
             var statusData = await statusesUserData.docs[j].reference.get();
             userStatuses.add(StatusModel.fromJson(statusData.data()!));
           }
             if ( userStatuses.isNotEmpty ){
              statuses.add(userStatuses);
             }
            
     }

     return statuses ;
       
  }
  
  @override
  Future<void> changeStorySeen({
    required String receiverId ,
    required String statusId
  }) async 
  {
    try {
         StatusModel statusModel ;
         List <String> isSeen = [];
         var statusData = await firestore.collection('users').doc(receiverId).collection('status').doc(statusId).get();
           statusModel = StatusModel.fromJson(statusData.data()!);
           
            if ( statusModel.isSeen!.isNotEmpty ) {
              for ( int i = 0 ; i < statusModel.isSeen!.length ; i++ ) {
                  isSeen.add(statusModel.isSeen![i]);
            }
            }

            isSeen.add(auth.currentUser!.uid);

          await firestore.collection('users').doc(receiverId).collection('status').doc(statusId).update({
            'isSeen' : isSeen
          });
    } catch (e) {
          showSnackBar(title: 'Error', message:  e.toString() );
    }
  }
  
  @override
  Future<void> setStorySeen({
    required String receiverId ,
    required String statusId
  }) async
   {  
      
        var userData = await firestore.collection('users').doc(auth.currentUser!.uid).get();
        
        WhoSeenStoryModel whoSeenStory = WhoSeenStoryModel(
          userName: userData['name'] ,
          dateTime: DateTime.now().toString(),
          profilePic: userData['profileImage'] ,
          time: DateFormat.jm().format(DateTime.now()),  
        );

     await firestore.collection('users').doc(receiverId).collection('status').doc(statusId).collection('whoSeen').doc(auth.currentUser!.uid).set(whoSeenStory.toMap());
  }
  
  @override
  Future<List<WhoSeenStoryModel>> getWhoSeenStory({
    required String receiverId ,
    required String statusId ,
  }) async
   {
        List <WhoSeenStoryModel> list = [];
       var data = await firestore.collection('users').doc(receiverId).collection('status').doc(statusId).collection('whoSeen').get();
       for ( int i = 0 ; i <  data.docs.length ; i++ ) {
             list.add( WhoSeenStoryModel.fromJson(data.docs[i].data()) );
       }

       return list ;
  }
  
 

         
    
}








