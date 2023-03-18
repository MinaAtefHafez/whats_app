

// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/last_message_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/type_class_message.dart';
import 'package:whats_app/view/controllers/auth_controller.dart';
import 'package:whats_app/view/controllers/home_controller.dart';
import 'package:whats_app/view/components/determine_type_message_fun.dart';
import 'package:whats_app/view/screens/contacts_screen.dart';
import 'package:whats_app/view/screens/single_chat_screen.dart';

class HomeChatScreen extends StatefulWidget {


  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {

  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Scaffold(
               backgroundColor: AppColors.mainColor,
               floatingActionButton:
            GetBuilder<AuthController>(builder: (authController) {
                 return FloatingActionButton(
            backgroundColor: AppColors.tabColor,
            onPressed: () {
              Get.to(() => ContactsScreen());
            },
            child: const Icon(Icons.chat),
                 );
               }),
             
               body: StreamBuilder<List<LastMessageModel>>(
              stream: homeController.showContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric( vertical: 10 , horizontal: 20   ),
                    child: ListView.separated(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildHomeItem(
                              model: snapshot.data![index],
                              baseMessage: determineMessageType(messageType: snapshot.data![index].messageType , 
                               
                              ),
                              );
                              
                         
                    } ,
                        separatorBuilder: (context,index) {  
                          return Padding(
                            padding: const EdgeInsets.only(left: 65 ),
                            child: Container(
                              height: 0.6 ,
                              color: AppColors.dividerColor,
                            
                            ),
                          );
                        } ,
                        ),
                      
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.tabColor,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
             );
    } );
  }


  Widget buildHomeItem(
      {
        required LastMessageModel model, 
        required BaseMessage baseMessage
      }) 
      {
    return InkWell(
      onTap: () async {
        var userData = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(model.contactId)
                                    .get();
                                UserModel userModel =
                                    UserModel.fromJson(userData.data()!);
                                Get.to(
                                    () => SingleChatScreen(userModel: userModel , groupModel: GroupModel(), isGroup: false , ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric( vertical: 15  ) ,
        width: double.infinity,
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: CachedNetworkImageProvider(
                model.profilePic ,
                ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                        color:  model.countMessagesThatNotSeen! > 0 ? AppColors.blueColor : AppColors.textColor,
                        fontWeight: model.countMessagesThatNotSeen! > 0 ? FontWeight.bold : FontWeight.w400  ,
                        fontSize: model.countMessagesThatNotSeen! > 0 ? 19 : 17),
                  ),
                  const SizedBox(
                    height: 7,
                  ),

                  baseMessage.typeLastMessageHomeChatItem(lastMessageModel: model, 
                  customTextStyle: customTextStyleForHomeChat(countMessagesThatNotSeen:model.countMessagesThatNotSeen! )),
                ],
              ),
            ),
             
              Visibility(
                visible: model.countMessagesThatNotSeen! > 0,
                replacement: Container(),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3.5),
                    
                    
                    decoration:  BoxDecoration(
                      color: AppColors.tabColor, 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(  model.countMessagesThatNotSeen.toString() , style: TextStyle(color: AppColors.greyWhiteColor),),
                  ), 
                ),

            const SizedBox(width: 20 ,) ,
            Builder(builder: (context) {
              String checkDateFromFireStore = model.dateMonthYear;
              String checkDateNow = DateFormat.yMd().format(DateTime.now());
                  
                 

              return Text(
                checkDateNow == checkDateFromFireStore
                    ? model.time
                    : model.dateMonthYear,
                style: TextStyle(color: AppColors.greyColor, fontSize: 11),
              );
            }),
          ],
        ),
      ),
    );
  }

  TextStyle customTextStyleForHomeChat ({
     required int countMessagesThatNotSeen
  }) 
  {
    return TextStyle(
      color: countMessagesThatNotSeen > 0 ? AppColors.greyWhiteColor : 
                    AppColors.greyColor, fontSize: 14.5,
                     fontWeight: countMessagesThatNotSeen > 0 ? FontWeight.bold : null ,
                    );
  }




}