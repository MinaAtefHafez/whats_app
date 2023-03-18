
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view_models/upload_storage_view_model.dart';

abstract class BaseGroupViewModel {
    Future <void> createGroup ({
    required String groupName ,
    required String lastMessage ,
    required File file ,
    required String senderId ,
    required List <String> membersUid ,
  });

  Stream <List<GroupModel>> getGroups() ;
}
 
 
class GroupViewModel implements BaseGroupViewModel {

   BaseUploadStorageViewModel uploadStorageViewModel   ;

   GroupViewModel({
    required this.uploadStorageViewModel
   });

   

  @override
  Future<void> createGroup({
    required String groupName ,
    required String lastMessage ,
     File? file ,
    required String senderId ,
    required List <String> membersUid ,
  }) async 
  {

             
           
           try {
                  String groupId = const Uuid().v1();
                  String groupPicUrl = '' ;
                  
             if ( file != null ) {
              groupPicUrl = (await uploadStorageViewModel.storeFileToFireStorage(imagePath: 'groupsPic/$groupId' , file: file))!;
             }
          
           GroupModel groupModel = GroupModel(
            groupName: groupName ,
            groupId:  groupId ,
            lastMessage: lastMessage ,
            groupPic:  groupPicUrl  ,
            membersUid: [ FirebaseAuth.instance.currentUser!.uid , ... membersUid ] ,
            senderId: senderId ,
            dateTime: DateTime.now().toString() ,
            date: DateFormat.yMd().format(DateTime.now()).toString() ,
            time: DateFormat.jm().format(DateTime.now()).toString() ,  
            whoSendLastMessage: ''  ,
            groupMessagesThatNotSeen: {},
           ); 

          await FirebaseFirestore.instance.collection('groups').doc(groupId).set(groupModel.toMap());

           } on FirebaseException catch (ex) {
             showSnackBar(title: '', message: ex.message!);
           } catch (e) {
                showSnackBar(title: 'Error', message: e.toString() );
           }

  }
  
  @override
  Stream<List<GroupModel>> getGroups() {
     return  FirebaseFirestore.instance.collection('groups').orderBy('dateTime' , descending: true  )
     .snapshots().map((event) {
         List <GroupModel> groups = [];
          for ( int i = 0 ; i  < event.docs.length ; i++ ) {
               groups.add(GroupModel.fromJson(event.docs[i].data()));
          }
          return groups ;

     });
  }
  
    

}