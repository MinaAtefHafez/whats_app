




import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view_models/group_view_model.dart';

import 'package:whats_app/view_models/home_view_model.dart';

class GroupController extends GetxController {

  BaseHomeViewModel homeViewModel;
  BaseGroupViewModel groupViewModel ;
  List <UserModel> createGroupContacts = [];
  LoadState createGroupState = LoadState.stable ;
  File? groupPic ; 
  GroupController({
   required this.homeViewModel,
   required this.groupViewModel
  });

  void pickGroupPic () async {
      var pick = await ImagePicker().pickImage(source: ImageSource.gallery);
      if ( pick != null ) {
        groupPic = File(pick.path) ;
      }
      update();
  }

    defaultGroupPic ({
     File? file
   }) 
   {
      if ( file != null ) {
        return FileImage(file);
      } else {
        return CachedNetworkImageProvider(AppConstants.defaultUserImageUrl);
      }
   } 

  List <String> membersUid ()
   {
     List<String> membersUid = [] ;
     for ( int i = 0 ; i < createGroupContacts.length ; i++ ) {
         membersUid.add(createGroupContacts[i].uId!);
     }

     return membersUid ;
  }

  Future<List<Contact>> getContacts() async {
    return await homeViewModel.getContacts();
  }


  void selectContactToCreateGroup ({
    required Contact selectedContact
  }) async 
  {
      bool isContactExist = false ;
      UserModel? userModel = await homeViewModel.selectContactToChat(selectContact: selectedContact);

      if ( userModel != null ) {
          for ( int i = 0 ; i < createGroupContacts.length ; i++ ) {
             
             String contact ;
             contact = userModel.phoneNumber! ;
             if ( contact == createGroupContacts[i].phoneNumber ) {
                 isContactExist = true ;
                 createGroupContacts.removeAt(i);
                 return ;
             } else if ( i == createGroupContacts.length - 1 && !isContactExist ) {
                isContactExist =false ;
             }
              
          }

          if ( !isContactExist ) {
            createGroupContacts.add(userModel);
          }

           
      } else {
        showSnackBar(title: 'This Contact Not Available on this App !', message: '' );
        
      }
     
  }

  bool isContactSelected ({
    required Contact selectedContact
  })
   {
             String firstChar = selectedContact.phones[0].number.split('')[0].toString();
             String contact ;
             if ( firstChar == '+' ) {
                contact = selectedContact.phones[0].number.replaceAll(' ', '').toString();
             } else {
              contact = '+2${selectedContact.phones[0].number.replaceAll(' ', '')}';
             }

           return createGroupContacts.any((element) => element.phoneNumber == contact );
      
  }


   void createGroup ({
    required String groupName ,
    required String lastMessage ,
    required File file ,
    required String senderId ,
    required List <String> membersUid ,
  }) async
   {
     createGroupState = LoadState.loading ;
     update();
     await groupViewModel.createGroup(groupName: groupName, lastMessage: lastMessage, file: file, senderId: senderId, membersUid: membersUid);
     createGroupState = LoadState.loaded ;
     groupPic = null ;
     update();
   }

  Stream <List<GroupModel>> getGroups () {
      return groupViewModel.getGroups();
  }

}
