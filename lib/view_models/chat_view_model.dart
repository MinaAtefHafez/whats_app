import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/core/services/dio_helper.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/last_message_model.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/models/react_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';

abstract class BaseChatViewModel {
  Future<void> sendMessage({
    required MessageModel messageModel
    
  });

  Future<void> saveLastMessageData({
    required String lastMessage,
    required String contactId,
    required String messageType ,
  });

  Stream<UserModel> isOnlineOrNot({required String uId});
  
  Stream <List<MessageModel>> getMessages({required String contactId});

   void sendReact ({
    required int reactType ,
    required String receiverId ,
    required String messageId
  }) ;

  Stream <List<ReactModel>> getReacts ({
    required String receiverId ,
    required String messageId ,
  }) ;

  void deleteMessage ({
    required bool isDeleteForEveryOne ,
   required String receiverId ,
   required String messageId
  }) ;
  
  void setSeen ({
    required String receiverId ,
    required String messageId
  }) ;

  // chat Group methods

  Future <void> saveGroupLastMessage ({
    required String groupId ,
    required String senderName ,
    required String laseMessage ,
    required String messageType
  }) ;

  Future<void> sendGroupMessage({
     String? text,
    required String receiverId,
    required String receiverName,
    required String senderName,
    required String messageType,
    required String fileUrl,
    required String repliedText,
    required String repliedType ,
    required String repliedFileUrl ,
    required String messageId ,
    required String repliedId ,
    required String groupId ,
    required String profilePic
  });

  void sendGroupReact ({
    required int reactType ,
    required String groupId ,
    required String messageId
  }) ;

  Stream <List<ReactModel>> getGroupReacts({
    required String groupId ,
    required String messageId ,
  });

   Stream <List<MessageModel>> getGroupMessages({required String groupId});

   void deleteGroupMessage( {
   required String messageId ,
   required String groupId
  });

  void changeMessagesThatNotSeenCount ({required String contactId});

  void sendNotification ({
    required  List<String> fcmTokens ,
    required String notificationTitle ,
    required String notificationBody ,
  }) ;

  void sendTextNotification ({
    required List <String> fcmTokens, 
    required String notificationBody , 
  }) ;

   void sendImageNotification ({
    required List <String> fcmTokens, 
  }) ;


  void sendVideoNotification ({
    required List <String> fcmTokens, 
  }) ;

  void sendAudioNotification ({
    required List <String> fcmTokens, 
  }) ;

  void sendTextNotificationToGroup ({
   
    required String notificationBody ,
    required List<String> membersUid 
  }) ;

  void sendImageNotificationToGroup ({
    required List<String> membersUid 
  }) ;

  void sendVideoNotificationToGroup ({
 
    required List<String> membersUid 
  }) ;

  void sendAudioNotificationToGroup ({
    required List<String> membersUid 
  }) ;
  
}



class ChatViewModel implements BaseChatViewModel {
  FirebaseFirestore fireStore;
  FirebaseAuth auth;
  FirebaseMessaging firebaseMessaging ;
  BaseDioHelper dioHelper ;
  ChatViewModel(this.fireStore, this.auth , this.firebaseMessaging , this.dioHelper );

  @override
  Stream<UserModel> isOnlineOrNot({required String uId}) {
    return fireStore.collection('users').doc(uId).snapshots().map((event) {
      return UserModel.fromJson(event.data()!);
    });
  }

  @override
  Future<void> saveLastMessageData({
     String? lastMessage,
    required String contactId,
    required String messageType ,
  }) async 
  {
    try {
      var senderData =
          await fireStore.collection('users').doc(auth.currentUser!.uid).get();
      var contactData =
          await fireStore.collection('users').doc(contactId).get();

      UserModel senderUserModel = UserModel.fromJson(senderData.data()!);
      UserModel contactUserModel = UserModel.fromJson(contactData.data()!);

      var contactLastMessageData = await fireStore.collection('users').doc(contactId).collection('chats').doc(auth.currentUser!.uid).get();
      var myLastMessageData = await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(contactId).get();
      
       int contactNewMessages = 1 ;
       int myNewMessages = 0 ;

      if ( contactLastMessageData.exists ) {
          contactNewMessages = contactLastMessageData.data()!['countMessagesThatNotSeen'] + 1 ;
      }

      if ( myLastMessageData.exists ) {
          myNewMessages = myLastMessageData.data()!['countMessagesThatNotSeen'] ;
      }      

      LastMessageModel senderModel = LastMessageModel(
          name: contactUserModel.name!,
          lastMessage: lastMessage ?? '' ,
          profilePic: contactUserModel.profileImage!,
          time:  DateFormat.jm().format(DateTime.now()) ,
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMd().format(DateTime.now()),  
          contactId: contactUserModel.uId! ,
          messageType:  messageType,
          countMessagesThatNotSeen: myNewMessages
          );

      LastMessageModel contactModel = LastMessageModel(
          name: senderUserModel.name!,
          lastMessage: lastMessage ?? '',
          profilePic: senderUserModel.profileImage!,
         time:  DateFormat.jm().format(DateTime.now()) ,
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMd().format(DateTime.now()) ,
          contactId: senderUserModel.uId!,
          messageType: messageType ,
          countMessagesThatNotSeen: contactNewMessages
          );

      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(contactId)
          .set(senderModel.toMap());
      await fireStore
          .collection('users')
          .doc(contactId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(contactModel.toMap());
    } catch (e) {
      showSnackBar(title: '', message: e.toString());
    }
  }


  @override
  Future<void> sendMessage({
    required MessageModel messageModel
  }) async
   {
    try {
      

      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(messageModel.receiverId)
          .collection('messages').doc(messageModel.messageId)
          .set(messageModel.toMap());
      await fireStore
          .collection('users')
          .doc(messageModel.receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages').doc(messageModel.messageId)
          .set(messageModel.toMap());
    } catch (e) {
      showSnackBar(title: '', message: e.toString());
    }
  }
  
  @override
 Stream <List<MessageModel>> getMessages({required String contactId})
 {
  
      return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .map((event) {
         List <MessageModel> messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      return messages;
    });
        
  }
  
  @override
  void sendReact({
    required int reactType, 
    required String receiverId, 
    required String messageId}) 
    async
     {
    var result = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel userModel = UserModel.fromJson(result.data()!);

    ReactModel reactModel =  ReactModel (
      reactType: reactType ,
      senderId: auth.currentUser!.uid ,
      nameSender: userModel.name ,
      imageSender: userModel.profileImage ,
      dateTime: DateTime.now().toString(),   
    ) ;
     
     try {

      await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats').
      doc(receiverId).collection('messages').doc(messageId).collection('reacts').
      doc(auth.currentUser!.uid).set(reactModel.toMap());

     await fireStore.collection('users').doc(receiverId).collection('chats').
      doc(auth.currentUser!.uid).collection('messages').doc(messageId).collection('reacts').
      doc(auth.currentUser!.uid).set(reactModel.toMap());

     } catch (e) {
      showSnackBar(title: 'Error', message: e.toString() );
     }

      
  }
  
  @override
  Stream <List<ReactModel>> getReacts({
    required String receiverId ,
    required String messageId ,
  }) 
   {
   return fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats')
   . doc(receiverId).collection('messages').doc(messageId).collection('reacts')
    .orderBy('dateTime')
    .snapshots().map((event) {
      List <ReactModel> reacts = [] ;
        for ( int i = 0 ; i < event.docs.length ; i++ ) {
             reacts.add(ReactModel.fromJson(event.docs[i].data()));
        }

        return reacts ;
    } );
    
  }
  
  
  @override
  void deleteMessage({
   required bool isDeleteForEveryOne ,
   required String receiverId ,
   required String messageId
  }) async 
  {
     
     if ( isDeleteForEveryOne ) {
         await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats')
          .doc(receiverId).collection('messages').doc(messageId).update({
              'isDeleted' : true
          });
        


          await fireStore.collection('users').doc(receiverId).collection('chats')
          .doc(auth.currentUser!.uid).collection('messages').doc(messageId).update({
              'isDeleted' : true
          });
      
     } else {

      var reactsForMe =   await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats')
          .doc(receiverId).collection('messages').doc(messageId).collection('reacts').get();

          for ( int i = 0 ; i < reactsForMe.docs.length ; i++ ) {
            reactsForMe.docs[i].reference.delete();
          }
       

      await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats')
       .doc(receiverId).collection('messages').doc(messageId).delete();
     }
      
  }
  

  @override
  void setSeen({
    required String receiverId ,
    required String messageId
  }) async 
  {
     try {

             await fireStore.collection('users').doc(receiverId).collection('chats').doc(auth.currentUser!.uid)
    .collection('messages').doc(messageId).update({
      'isSeen' : true
    });

    await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverId)
    .collection('messages').doc(messageId).update({
      'isSeen' : true
    });
    
     } catch (e) {
          showSnackBar(title: 'Error', message:  e.toString() );
     }
  }
  
  // group Chat methods


   @override
  Future <void> saveGroupLastMessage({
    required String groupId ,
    required String senderName ,
    required String laseMessage ,
    required String messageType
  }) async 
  {

     Map <String , dynamic> mapMessagesThatNotSeen = {} ;
     final groupData = await fireStore.collection('groups').doc(groupId).get();
      final GroupModel groupModel = GroupModel.fromJson(groupData.data()!);
        
        if ( groupModel.groupMessagesThatNotSeen!.isEmpty ) {
              for ( int i = 0 ; i < groupModel.membersUid!.length ; i++ ) {
                    if ( groupModel.membersUid![i] != FirebaseAuth.instance.currentUser!.uid ) {
                      mapMessagesThatNotSeen.addAll({
                        groupModel.membersUid![i] : 1
                      });
                    } else {
                      mapMessagesThatNotSeen.addAll({
                        groupModel.membersUid![i] : 0
                      });
                    }  
              }
        } else {
              
               mapMessagesThatNotSeen.addAll(groupModel.groupMessagesThatNotSeen!); 
              mapMessagesThatNotSeen.updateAll((key, value)=> key != FirebaseAuth.instance.currentUser!.uid ? value = value + 1 : value);
        }

        try {
              await fireStore.collection('groups').doc(groupId).update({
                'lastMessage' : laseMessage ,
                'whoSendLastMessage' : senderName ,
                'date' : DateFormat.yMd().format(DateTime.now()) ,
                'time' : DateFormat.jm().format(DateTime.now()) ,
                 'messageType' : messageType ,
                 'groupMessagesThatNotSeen' : mapMessagesThatNotSeen
              });
        } on FirebaseException catch (ex) {
          showSnackBar(title: '', message: ex.message!);
        }
  }


  @override
  Future<void> sendGroupMessage({
    String? text, 
    required String receiverId,
     required String receiverName,
      required String senderName, 
      required String messageType,
       required String fileUrl,
        required String repliedText, 
        required String repliedType, 
        required String repliedFileUrl, 
        required String messageId, 
        required String repliedId ,
        required String groupId ,
        required String profilePic ,
        }) async
        {   

        await  saveGroupLastMessage(groupId: groupId, senderName: senderName, laseMessage: text! ,
          messageType: messageType 
        );

                try {
          MessageModel messageModel = MessageModel(
          text: text ,
          type: messageType,
          senderId: auth.currentUser!.uid,
          receiverId: receiverId,
          profilePic: profilePic ,
          time: DateFormat.jm().format(DateTime.now()),
          dateTime: DateTime.now().toString(),
          dateMonthYear: DateFormat.yMMMMd().format(DateTime.now()).toString(),
          fileUrl: fileUrl ,
          isSeen: false, 
          repliedText: repliedText  ,
          repliedType: repliedType ,
          repliedFileUrl: repliedFileUrl ,
          messageId: messageId  ,
          contactName: receiverName ,
          senderName: senderName ,
          repliedId: repliedId ,
          isDeleted: false 
          );
         await fireStore.collection('groups').doc(groupId).collection('messages').doc(messageId).set(messageModel.toMap()); 

                } catch (e) {
              showSnackBar(title: 'Error', message: e.toString() );
                }              
  }
  
  
  @override
  void sendGroupReact({
    required int reactType,
     required String groupId ,
      required String messageId ,
      }) async 
      {
           var result = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
           UserModel userModel = UserModel.fromJson(result.data()!);  

      ReactModel reactModel =  ReactModel (
      reactType: reactType ,
      senderId: auth.currentUser!.uid ,
      nameSender: userModel.name ,
      imageSender: userModel.profileImage ,
      dateTime: DateTime.now().toString(),   
    ) ;


     try {

     await fireStore.collection('groups').doc(groupId).collection('messages').doc(messageId).collection('reacts')
      .doc(auth.currentUser!.uid).set(reactModel.toMap());

     } catch (e) {
      showSnackBar(title: 'Error', message: e.toString() );
     }
  }
  
  @override
  Stream<List<ReactModel>> getGroupReacts({
    required String groupId,
     required String messageId
    }) 
    {
      return fireStore.collection('groups').doc(groupId).collection('messages').doc(messageId).collection('reacts').orderBy('dateTime')
    .snapshots().map((event) {
      List <ReactModel> reacts = [] ;
        for ( int i = 0 ; i < event.docs.length ; i++ ) {
             reacts.add(ReactModel.fromJson(event.docs[i].data()));
        }

        return reacts ;
    } );
  }
  
  @override
  Stream<List<MessageModel>> getGroupMessages({required String groupId}) {
      return fireStore
        .collection('groups').doc(groupId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .map((event) {
         List <MessageModel> messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      return messages;
    });
  }
  
  @override
  void deleteGroupMessage({
    required String groupId ,
     required String messageId}) 
     {
       fireStore.collection('groups').doc(groupId).collection('messages').doc(messageId).update({
            'isDeleted' : true
       });
  }
  
  @override 
  void changeMessagesThatNotSeenCount({
    required String contactId,
  }) async 
  {
         

     try {
          
         var data = await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(contactId).get();
         
          if ( data.exists ) {
            await fireStore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(contactId).update({
            'countMessagesThatNotSeen' : 0
       });
          }
          
     } on FirebaseException catch (exception) { 
           showSnackBar(title: 'Error' , message: exception.toString() );
     } catch (e) {
        showSnackBar(title: 'error occurred !', message: 'try later'); 
     }
  }
  
  @override
  void sendNotification({
    required List <String> fcmTokens, 
    required String notificationTitle ,
    required String notificationBody , 
  }) async 
  {
        
      final data =  {
    "registration_ids": fcmTokens ,
    "notification": {
        "body": notificationBody.toString() ,
        "title": notificationTitle ,
        "sound": true
    }
} ; 

    await dioHelper.postData(url: AppConstants.sendNotificationUrl , data: data);  
  }
  
  @override
  void sendTextNotification({

   required List <String> fcmTokens, 
    required String notificationBody , 

  }) async 
  {
           
     var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
     sendNotification(fcmTokens: fcmTokens, notificationTitle: senderData.data()!['name'], notificationBody: notificationBody);

    }
    
      @override
      void sendImageNotification({required List<String> fcmTokens}) async 
      {
    var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
     sendNotification(fcmTokens: fcmTokens, notificationTitle: senderData.data()!['name'], notificationBody: 'Image');
      }
      
        @override
        void sendVideoNotification({required List<String> fcmTokens}) async 
        {
          var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
     sendNotification(fcmTokens: fcmTokens, notificationTitle: senderData.data()!['name'], notificationBody: 'Video');
        }
        
          @override
          void sendAudioNotification({required List<String> fcmTokens}) async 
          {
            var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
     sendNotification(fcmTokens: fcmTokens, notificationTitle: senderData.data()!['name'], notificationBody: 'Audio');
          }
          
            @override
            void sendTextNotificationToGroup({

               required String notificationBody ,
               required List<String> membersUid
            }) async 
            {
              List <String> groupMembersTokens = [] ;
              var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
            
            for ( int i = 0 ; i < membersUid.length ; i++ ) {
               var memberData  = await fireStore.collection('users').doc(membersUid[i]).get();
                UserModel userModel = UserModel.fromJson(memberData.data()!);
               groupMembersTokens.add(userModel.fcmToken!);
            }

              sendNotification(fcmTokens: groupMembersTokens, notificationTitle: senderData.data()!['name'] , notificationBody: notificationBody);

            }
            
              @override
              void sendAudioNotificationToGroup({ required List<String> membersUid}) async 
              {
                List <String> groupMembersTokens = [] ;
              var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
            
            for ( int i = 0 ; i < membersUid.length ; i++ ) {
               var memberData  = await fireStore.collection('users').doc(membersUid[i]).get();
                UserModel userModel = UserModel.fromJson(memberData.data()!);
               groupMembersTokens.add(userModel.fcmToken!);
            }

              sendNotification(fcmTokens: groupMembersTokens, notificationTitle: senderData.data()!['name'] , notificationBody: 'Audio');
              }
            
              @override
              void sendImageNotificationToGroup({required List<String> membersUid}) async 
              {
                List <String> groupMembersTokens = [] ;
              var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
            
            for ( int i = 0 ; i < membersUid.length ; i++ ) {
               var memberData  = await fireStore.collection('users').doc(membersUid[i]).get();
                UserModel userModel = UserModel.fromJson(memberData.data()!);
               groupMembersTokens.add(userModel.fcmToken!);
            }

              sendNotification(fcmTokens: groupMembersTokens, notificationTitle: senderData.data()!['name'] , notificationBody: 'Image');
               
              }
            
              @override
              void sendVideoNotificationToGroup({ required List<String> membersUid} ) async 
              {
               List <String> groupMembersTokens = [] ;
              var senderData = await fireStore.collection('users').doc(auth.currentUser!.uid).get();
            
            for ( int i = 0 ; i < membersUid.length ; i++ ) {
               var memberData  = await fireStore.collection('users').doc(membersUid[i]).get();
                UserModel userModel = UserModel.fromJson(memberData.data()!);
               groupMembersTokens.add(userModel.fcmToken!);
            }

              sendNotification(fcmTokens: groupMembersTokens, notificationTitle: senderData.data()!['name'] , notificationBody: 'Video');
              }




  
  
  

}
