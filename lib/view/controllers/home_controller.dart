import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/last_message_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view/screens/groups_chat_screen.dart';
import 'package:whats_app/view/screens/home_chat_screen.dart';
import 'package:whats_app/view/screens/single_chat_screen.dart';
import 'package:whats_app/view/screens/status_contacts_screen.dart';
import 'package:whats_app/view_models/home_view_model.dart';


class HomeController extends GetxController {
  HomeController(this.homeViewModel);

  BaseHomeViewModel homeViewModel;
  List <String> tabBarList = [
    'CHATS' ,
     'STATUS' ,
      'GROUPS' 
  ];

  List <Widget> homeScreens = [
    HomeChatScreen() ,
    StatusContactsScreen() ,
    GroupsChatScreen()
  ];

  List<Contact> contacts = [];
  UserModel? selectedUser;
  

  @override
  void onInit() async {
    super.onInit();
    await getContacts();
  }

  

  Future<void> getContacts() async {
    contacts = await homeViewModel.getContacts();
    update();
  }

  void selectContactToChat({required Contact selectContact}) async
   {
    selectedUser =
        await homeViewModel.selectContactToChat(selectContact: selectContact);

    if (selectedUser != null) {
      Get.to(() => SingleChatScreen(
            userModel: selectedUser!,
            groupModel: GroupModel(),
            isGroup: false ,
          ));
    } else {
      showSnackBar(
          title: 'This phone number not available on this app !', message: '');
    }
    update();
  }

 
   Stream<List<LastMessageModel>> showContacts() {
      return homeViewModel.showAllChatContacts();
   }
   
  
   

 
}
