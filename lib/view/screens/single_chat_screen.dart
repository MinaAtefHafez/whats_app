// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/call_model.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/call_received_item.dart';
import 'package:whats_app/view/components/custom_button.dart';
import 'package:whats_app/view/components/receiver_message_item.dart';
import 'package:whats_app/view/components/replied_item.dart';
import 'package:whats_app/view/components/sender_message_item.dart';
import 'package:whats_app/view/controllers/call_controller.dart';
import 'package:whats_app/view/controllers/chat_controller.dart';
import 'package:whats_app/view/components/determine_type_message_fun.dart';
import 'package:whats_app/view/screens/settings_screen.dart';

import 'contact_information_screen.dart';


class SingleChatScreen extends StatefulWidget {
  UserModel userModel;
  GroupModel groupModel ;
  bool isGroup ;
  SingleChatScreen({required this.userModel , required this.groupModel , required this.isGroup});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState(); 
}

class _SingleChatScreenState extends State<SingleChatScreen> {

  TextEditingController textController = TextEditingController();
  bool isShowSendButton = false;
  bool isShowEmojiPicker = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder soundRecorder = FlutterSoundRecorder(); 
  bool isRecorderInit = false;
  bool isRecording = false;
  MessageModel swipeModel = MessageModel();
  String notificationTextBody = '' ; 

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  @override
  void dispose() async {
    super.dispose();
    await soundRecorder.closeRecorder(); 
    isRecorderInit = false;
  }

  void initAudio() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission not allowed!');
    }
    await soundRecorder.openRecorder();
    isRecorderInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(builder: (callController) {
     return StreamBuilder<CallModel>(
        stream: callController.callStream , 
        builder: (context,snapshot) 
        {
          if ( snapshot.hasData && snapshot.data != null && !snapshot.data!.hasDialled ) {
                return CallReceivedItem(
                  callModel: snapshot.data! ,
                              isGroup: widget.isGroup,
                );
          } else {
              return GetBuilder<ChatController>(builder: (chatController) {
      return Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: appBar(chatController),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/back_chat.jpg',
              fit: BoxFit.cover, 
              height: double.infinity,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  StreamBuilder<List<MessageModel>>(
                      stream: !widget.isGroup ?  chatController.getMessages(
                          contactId: widget.userModel.uId!) : chatController.getGroupMessages(groupId: widget.groupModel.groupId! ) ,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            chatController.messagesController.jumpTo(
                                chatController.messagesController.position
                                    .maxScrollExtent);
                          });
                          return Expanded(
                            child: ListView.builder(
                                controller: chatController.messagesController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  
                                  // change seen
                                !widget.isGroup ? 
                                setSeen(
                                  chatController: chatController,
                                  senderId: snapshot.data![index].senderId!, 
                                  messageId: snapshot.data![index].messageId!, 
                                  isSeen: snapshot.data![index].isSeen!) : null ;


                                  if (snapshot.data![index].senderId ==
                                      FirebaseAuth.instance.currentUser!.uid) {
                                    return SwipeTo(
                                      onRightSwipe: () {
                                        isReplied = true;
                                        swipeModel = snapshot.data![index];
                                        setState(() {});
                                      },
                                      child: InkWell(
                                        onLongPress: () => chooseReacts(
                                          chatController: chatController ,
                                          receiverId: FirebaseAuth.instance.currentUser!.uid ==
                                            snapshot.data![index].senderId! ? 
                                          snapshot.data![index].receiverId! 
                                          : snapshot.data![index].senderId! ,
                                          messageId: snapshot
                                                .data![index].messageId!,
                                          isDeleted: snapshot
                                                .data![index].isDeleted!
                                        ), 
                                        onDoubleTap: () =>
                                            showDialogToRemoveMessage(
                                          chatController: chatController,
                                          messageModel: snapshot.data![index],
                                        ),
                                        child: BuildSenderMessage(
                                          messageModel: snapshot.data![index],
                                          isGroup: widget.isGroup,
                                          groupModel: widget.groupModel,
                                          prevMessageModel: index > 0
                                              ? snapshot.data![index - 1]
                                              : MessageModel(),
                                            baseMessage: determineMessageType(messageType: snapshot.data![index].type!,
                                            repliedMessageType: snapshot.data![index].repliedType!
                                            ) ,
                                        
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SwipeTo(
                                      onRightSwipe: () {
                                        isReplied = true;
                                        swipeModel = snapshot.data![index];
                                        setState(() {});
                                      },
                                      child: InkWell(
                                        onLongPress: () => chooseReacts(
                                            chatController: chatController,
                                            receiverId:
                                                snapshot.data![index].senderId!,
                                            messageId: snapshot
                                                .data![index].messageId!,
                                            isDeleted: snapshot
                                                .data![index].isDeleted!),
                                        onDoubleTap: () =>
                                            showDialogToRemoveMessage(
                                          chatController: chatController,
                                          messageModel: snapshot.data![index],
                                        ),
                                        child: BuildReceiverMessage(
                                          messageModel: snapshot.data![index],
                                          groupModel: widget.groupModel,
                                          isGroup: widget.isGroup,
                                          prevMessageModel: index > 0
                                              ? snapshot.data![index - 1]
                                              : MessageModel(),
                                          name: widget.userModel.name!,
                                          baseMessage: determineMessageType(messageType: snapshot.data![index].type!,
                                             repliedMessageType: snapshot.data![index].repliedType!
                                           ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemCount: snapshot.data!.length),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                                color: AppColors.tabColor),
                          ));
                        } else {
                          return Expanded(child: Container());
                        }
                      }),
                  showLinearProgressIndicator(chatController: chatController),
                  const SizedBox(
                    height: 5,
                  ),
                  bottomChatBar(
                    textController: textController,
                    userModel: widget.userModel,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (isShowEmojiPicker)
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: EmojiPicker(
                        config: const Config(
                          bgColor: AppColors.mainColor,
                          iconColorSelected: AppColors.tabColor,
                          indicatorColor: AppColors.tabColor,
                          loadingIndicator: CircularProgressIndicator(color: AppColors.tabColor ,) ,
                        ),
                        onEmojiSelected: (category, emoji) {
                          setState(() {
                            textController.text =
                                '${textController.text}${emoji.emoji}';
                            isShowSendButton = true;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
          }
        } , 
        );
    } );
  }

  AppBar appBar(ChatController chatController) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      titleSpacing: 5.0,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: AppColors.appBarColor),
      title: InkWell(
        onTap: (){
           if ( widget.userModel.name!.isNotEmpty  ) {
                 Get.to(ContactInformationScreen(contactUserModel: widget.userModel));
           }
        } ,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  CachedNetworkImageProvider( !widget.isGroup ? widget.userModel.profileImage! : widget.groupModel.groupPic! ) ,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   !widget.isGroup ? widget.userModel.name! : widget.groupModel.groupName! ,
                    style:
                        const TextStyle(color: AppColors.textColor, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                !widget.isGroup ? StreamBuilder<UserModel>(
                      stream:
                          chatController.isOnlineOrNot(uId: widget.userModel.uId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isOnline!) {
                            return Row(
                              children: const [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: AppColors.tabColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'online',
                                      style: TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 10),
                                    )),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }) : Container() ,
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.appBarColor,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textColor,
            )),
      ),
      actions: [
        GetBuilder<CallController>(
          builder: (callController) {
            return IconButton(onPressed: () {
              callController.makeCall(
                userModel: widget.userModel ,
                groupModel: widget.groupModel
              );
            }, icon: const Icon(Icons.video_call));
          } ,
          ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget bottomChatBar({
    required TextEditingController textController,
    required UserModel userModel,
  }) 
  {
    return GetBuilder<ChatController>(builder: (chatController) {
        !widget.isGroup ? chatController.changeMessagesThatNotSeenCount(contactId: widget.userModel.uId! ) : null ; 
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              children: [
                RepliedItem(
                  messageModel: swipeModel,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  height: 47,
                  decoration: BoxDecoration(
                      color: AppColors.chatBarColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (!isShowEmojiPicker) {
                              focusNode.unfocus();
                              setState(() {
                                isShowEmojiPicker = !isShowEmojiPicker;
                              });
                            } else {
                              setState(() {
                                isShowEmojiPicker = !isShowEmojiPicker;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: AppColors.greyColor,
                          )),
                      Expanded(
                        child: TextFormField(
                          controller: textController,
                          style: const TextStyle(color: AppColors.textColor),
                          textDirection: TextDirection.rtl,
                          focusNode: focusNode,
                          cursorColor: AppColors.tabColor,
                          decoration: InputDecoration(
                            hintText: 'Type a message ...',
                            hintStyle: TextStyle(
                                color: AppColors.greyColor, fontSize: 16),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                isShowSendButton = true;
                                notificationTextBody = value ;
                              } else {
                                isShowSendButton = false;
                              }
                            });
                          },
                          onTap: () {
                            setState(() {
                              isShowEmojiPicker = false;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await chatController.pickedImage();

                            showBottomSheetToSendImage(
                                isImage: true,
                                file: chatController.imageFile!,
                                chatController: chatController );
                    
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColors.greyColor,
                          )),
                      IconButton(
                          onPressed: () async {
                            await chatController.pickedVideo();
                           !widget.isGroup ? await chatController.sendVideoMessage(
                              text: textController.text.trim(),
                              
                              contactId: userModel.uId!,
                              swipeModel: swipeModel,
                              isReplied: isReplied,

                            ) : await chatController.sendGroupMessage(
                                    text: textController.text.trim(),
                                       swipeModel: swipeModel, 
                                        isReplied: isReplied, 
                                         groupId: widget.groupModel.groupId!
                                         ) ;

                                    !widget.isGroup ? chatController.sendVideoMessageNotification(fcmTokens: [widget.userModel.fcmToken!]) : 
                                                     chatController.sendVideoMessageNotificationToGroup(membersUid: widget.groupModel.membersUid! ); 
                            isReplied = false;
                          },
                          icon: Icon(
                            Icons.attach_file,
                            color: AppColors.greyColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              if ( isShowSendButton ) {
                sendTextMessage(
                  chatController: chatController,
                  text: textController.text.trim(),
                  messageType: 'text',
                  userModel: userModel
                  );
              } else {
                sendAudioMessage(chatController: chatController,
                 text: textController.text.trim(), 
                 messageType: 'audio',
                  userModel: userModel);
              }
              textController.clear();
            },
            child: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.tabColor,
                child: Icon(
                  !isShowSendButton
                      ? isRecording
                          ? Icons.close
                          : Icons.mic
                      : Icons.send,
                  color: AppColors.textColor,
                  size: 30,
                )),
          ),
        ],
      );
    });
  }

  
  void sendTextMessage({
    required ChatController chatController,
    required String text,
    required String messageType,
    required UserModel userModel,
  }) async 
  {
    setState(() {
        isShowSendButton = false;
      });
     !widget.isGroup ? await chatController.sendTextMessage(
        text: text.trim(),
        
        contactId: userModel.uId!,
        isReplied: isReplied,
        swipeModel: swipeModel,
      ) : await chatController.sendGroupMessage(
                                    text: textController.text.trim(), 
                                       swipeModel: swipeModel, 
                                        isReplied: isReplied, 
                                         groupId: widget.groupModel.groupId!
                                         ) ;
           
      !widget.isGroup ? chatController.sendTextMessageNotification(fcmTokens: [widget.userModel.fcmToken!] , notificationBody: notificationTextBody) :
                       chatController.sendTextMessageNotificationToGroup(notificationBody: notificationTextBody, membersUid: widget.groupModel.membersUid!);
     
      isReplied = false;
      setState(() {});
  }

  void sendAudioMessage ({
    required ChatController chatController ,
    required String text,
    required String messageType,
    required UserModel userModel,
  }) async
  {

    var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/audio.aac';

      if (!isRecorderInit) {
        return;
      }

      if (isRecording) {
        await soundRecorder.stopRecorder();
        chatController.audioFile = File(path);
       !widget.isGroup ?  
       await chatController.sendAudioMessage(
          text: text,
          contactId: userModel.uId!,
          swipeModel: swipeModel,
          isReplied: isReplied,
        ) 
        : 
        await chatController.sendGroupMessage(
                                    text: textController.text.trim(),
                                       swipeModel: swipeModel, 
                                        isReplied: isReplied, 
                                         groupId: widget.groupModel.groupId!
                                         ) ;
            
            !widget.isGroup ? 
            chatController.sendAudioMessageNotification(fcmTokens: [widget.userModel.fcmToken!] ) :
            chatController.sendAudioMessageNotificationToGroup(membersUid: widget.groupModel.membersUid!);

        setState(() {
          isReplied = false;
        });
      } else {
        await soundRecorder.startRecorder(toFile: path);
      }

      setState(() {
        isRecording = !isRecording;
      });
  }

  void showBottomSheetToSendImage(
      {required bool isImage,
      required File file,
      required ChatController chatController}) 
      {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: isImage
                    ? Image.file(file)
                    : Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            color: AppColors.blackColor,
                          ),
                          Icon(
                            Icons.play_arrow,
                            color: AppColors.greyWhiteColor,
                          )
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(text: 'Send', 
            onPressed: () async{
                   Get.back();

                  !widget.isGroup ?  await chatController.sendImageMessage(
                   text: textController.text.trim(),            
                 contactId: widget.userModel.uId!,
                    swipeModel: swipeModel,
                  isReplied: isReplied ) : 
                  await chatController.sendGroupMessage(
                                    text: textController.text.trim(),
                                       swipeModel: swipeModel, 
                                        isReplied: isReplied, 
                                         groupId: widget.groupModel.groupId!
                                         ) ;

                      !widget.isGroup ? chatController.sendImageMessageNotification(fcmTokens: [widget.userModel.fcmToken!]) :
                                        chatController.sendImageMessageNotificationToGroup(membersUid: widget.groupModel.membersUid! ); 
                                  isReplied = false;
            } ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: AppColors.appBarColor,
    );
  }
   

  Widget showLinearProgressIndicator({required ChatController chatController}) 
  {
    if ((chatController.sendMessageState == LoadState.loading &&
            chatController.imageFile != null) ||
        (chatController.sendMessageState == LoadState.loading &&
            chatController.videoFile != null) ||
        (chatController.audioFile != null &&
            chatController.sendMessageState == LoadState.loading)) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: Get.width * 0.2),
        child: const LinearProgressIndicator(
          color: AppColors.tabColor,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void chooseReacts(
      {required ChatController chatController,
      required String receiverId,
      required String messageId,
      required bool isDeleted})
       {
    if (!isDeleted) {
      Get.bottomSheet(
        Container(
          alignment: Alignment.center,
          height: 100,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                   !widget.isGroup ? chatController.sendReact(
                        reactType: index,
                        receiverId: receiverId,
                        messageId: messageId) : chatController.sendGroupReact(
                          reactType: index,
                           groupId: widget.groupModel.groupId!, 
                            messageId: messageId
                            ) ;
                  },
                  child: Text(
                    chatController.reactsList[index],
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            },
            itemCount: chatController.reactsList.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: AppColors.mainColor,
      );
    }
  }

  void showDialogToRemoveMessage(
      {required ChatController chatController,
      required MessageModel messageModel}) 
    {
    Get.defaultDialog(
      title: 'Delete Message ?',
      contentPadding: const EdgeInsets.all(10),
      titleStyle: const TextStyle(color: AppColors.textColor, fontSize: 15),
      backgroundColor: AppColors.appBarColor,
      content: Row(
        children: [
          if (!messageModel.isDeleted!)
            Expanded(
                child: TextButton(
                    onPressed: () {
                      Get.back();
                     !widget.isGroup ? chatController.deleteMessage(
                          isDeleteForEveryOne: true,
                          receiverId: messageModel.receiverId!,
                          messageId: messageModel.messageId!) : 
                          chatController.deleteGroupMessage(messageId: messageModel.messageId!, groupId: widget.groupModel.groupId!) ;
                    },
                    child: const Text('Delete for everyone',
                        style: TextStyle(
                          color: AppColors.tabColor,
                          fontSize: 12,
                        )))),
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.tabColor, fontSize: 12))),
         !widget.isGroup ? TextButton(
              onPressed: () {
                Get.back();
                chatController.deleteMessage(
                    isDeleteForEveryOne: false,
                    receiverId: messageModel.receiverId!,
                    messageId: messageModel.messageId!);
              },
              child: const Text('Delete at me',
                  style: TextStyle(color: AppColors.tabColor, fontSize: 12))) : Container() ,
        ],
      ),
    );
  }

  void setSeen({
    required ChatController chatController,
    required String senderId,
    required String messageId,
    required bool isSeen,
  })
   {
    if (senderId != FirebaseAuth.instance.currentUser!.uid && !isSeen) {
      chatController.setSeen(receiverId: senderId, messageId: messageId);
    }
  }

 

}
