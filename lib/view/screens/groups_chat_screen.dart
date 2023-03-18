
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/controllers/group_controller.dart';
import 'package:whats_app/view/screens/single_chat_screen.dart';


class GroupsChatScreen extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupController>(
      builder: (groupController) {
      return Scaffold(
      appBar: appBar,
      backgroundColor: AppColors.mainColor,
      body: listGroupsChat(groupController: groupController),
    );
    } );
  }

  AppBar appBar = AppBar(
    backgroundColor: AppColors.appBarColor,
    title: const Text(
      'Groups Chat' , style: TextStyle( color: AppColors.tabColor , fontWeight: FontWeight.w400 ,fontSize: 15 )) ,
    titleSpacing: 0.0,
    centerTitle: true ,
  );

  Widget listGroupsChat ({
    required GroupController groupController
  })
  {
    return StreamBuilder<List<GroupModel>>(
      stream: groupController.getGroups() ,
      builder: ((context, snapshot) {
                if ( snapshot.hasData ) {
                  if ( snapshot.data!.isNotEmpty ) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.separated(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context,index) {
                            return InkWell(
                              onTap: (){
                                Get.to( () => SingleChatScreen(userModel: UserModel() , groupModel: snapshot.data![index], isGroup: true ) );
                              } ,
                              child: groupItem(model: snapshot.data![index]));
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
                  }else {
                      return Container();
                  }
                } else {
                      return Container();
                }
      }) 
      );
  }

  Widget groupItem ({
    required GroupModel model
  }) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 12  ),
      child: Row(
        children: [ 
          CircleAvatar(
                radius: 27,
                backgroundImage: CachedNetworkImageProvider(
                  model.groupPic! ,
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
                      model.groupName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Builder(builder: (context) {
                        switch ( model.messageType ) {
                          case 'text' : return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         model.whoSendLastMessage != ''  ? '${model.whoSendLastMessage!.split(' ')[0]} : ' : '' ,
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                    
                        Expanded(
                          child: Text(
                           model.lastMessage != ''  ? '${model.lastMessage}' : '' ,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(color: AppColors.greyColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ); 
                       case 'image' : return  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         model.whoSendLastMessage != ''  ? '${model.whoSendLastMessage!.split(' ')[0]} : ' : '' ,
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                    
                        Row(
                          children: [
                            Text(
                    'Photo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.greyColor, fontSize: 11),
                  ),
                  const SizedBox(width: 3 ,),
                            const Icon(Icons.camera_alt, color: AppColors.tabColor, size: 15 , ),
                          ],
                        ),
                      ],
                    );
                        case 'video' : return  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         model.whoSendLastMessage != ''  ? '${model.whoSendLastMessage!.split(' ')[0]} : ' : '' ,
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                    
                        Row(
                          children: [
                             Text(
                    'Video',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.greyColor, fontSize: 11),
                  ),
                   const SizedBox(width: 3 ,),
                            const Icon(Icons.video_settings , color: Colors.deepOrange , size: 17 , ),
                          ],
                        ),
                      ],
                    );
                      case 'audio' : return  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         model.whoSendLastMessage != ''  ? '${model.whoSendLastMessage!.split(' ')[0]} : ' : '' ,
                          style: const TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                    
                        Row(
                          children: [
                             Text(
                    'Audio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.greyColor, fontSize: 11),
                  ),
                  const SizedBox(width: 3 ,),
                            const Icon(Icons.audiotrack_outlined , color: Colors.deepOrange , size: 17 , ),
                          ],
                        ),
                      ],
                    );

                    default : return Container();
                        }
                    } ),
                  ],
                ),
              ) ,

               Visibility(
                visible: model.groupMessagesThatNotSeen![FirebaseAuth.instance.currentUser!.uid] > 0 ,
                replacement: Container(),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(3.5),
                    
                    
                    decoration:  BoxDecoration(
                      color: AppColors.tabColor, 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(  model.groupMessagesThatNotSeen![FirebaseAuth.instance.currentUser!.uid].toString() , style: TextStyle(color: AppColors.greyWhiteColor),),
                  ), 
                ),
              const SizedBox(width: 20 ,),
              Builder(builder: (context) {
                String checkDateFromFireStore = model.date!;
                String checkDateNow = DateFormat.yMd().format(DateTime.now());
                    
                return Text(
                  checkDateNow == checkDateFromFireStore
                      ? model.time!
                      : model.date!,
                  style: TextStyle(color: AppColors.greyColor, fontSize: 11),
                );
              }),
        ],
      ),
    );
  }
}