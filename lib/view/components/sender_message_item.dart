// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/group_model.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/models/react_model.dart';
import 'package:whats_app/view/components/deleted_message_item.dart';
import 'package:whats_app/view/components/display_dateTime_item.dart';
import 'package:whats_app/view/components/type_class_message.dart';
import 'package:whats_app/view/controllers/chat_controller.dart';

class BuildSenderMessage extends StatefulWidget {
  MessageModel messageModel;
  MessageModel prevMessageModel;
  bool isGroup;
  GroupModel groupModel;
  BaseMessage baseMessage;

  BuildSenderMessage({
    required this.messageModel,
    required this.prevMessageModel,
    required this.groupModel,
    required this.isGroup,
    required this.baseMessage,
  });

  @override
  State<BuildSenderMessage> createState() => _BuildSenderMessageState();
}

class _BuildSenderMessageState extends State<BuildSenderMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildDateTimeItem(
                  messageModel: widget.messageModel,
                  prevMessageModel: widget.prevMessageModel),
              buildSenderMainItem(
                  isDeleted: widget.messageModel.isDeleted!,
                  chatController: chatController),
            ],
          ),
        ),
      );
    });
  }

  void showAllReacts(
      {required List<ReactModel> reacts,
      required ChatController chatController}) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('${reacts.length}  reacts',
                style: TextStyle(color: AppColors.greyColor)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return buildReactItem(
                        reactModel: reacts[index],
                        chatController: chatController);
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: 15);
                  },
                  itemCount: reacts.length),
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      backgroundColor: AppColors.mainColor,
    );
  }

  Widget buildReactItem(
      {required ReactModel reactModel,
      required ChatController chatController}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(reactModel.imageSender!),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          FirebaseAuth.instance.currentUser!.uid == reactModel.senderId
              ? 'You'
              : reactModel.nameSender!,
          style: TextStyle(
              color:
                  FirebaseAuth.instance.currentUser!.uid != reactModel.senderId
                      ? AppColors.textColor
                      : AppColors.deepPurple,
              fontSize: 17,
              fontWeight: FontWeight.w400),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )),
        Text(
          chatController.reactsList[reactModel.reactType!],
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget buildSenderMainItem(
      {required bool isDeleted, required ChatController chatController}) {
    if (!isDeleted) {
      return Container(
        width: widget.messageModel.type == 'image' ? Get.width * 0.65 : null,
        decoration: const BoxDecoration(
          color: AppColors.senderMessageColor,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(20),
            topEnd: Radius.circular(20),
            topStart: Radius.circular(20),
          ),
        ),
        child: StreamBuilder<List<ReactModel>>(
          stream: !widget.isGroup
              ? chatController.getReacts(
                  receiverId: FirebaseAuth.instance.currentUser!.uid ==
                          widget.messageModel.senderId!
                      ? widget.messageModel.receiverId!
                      : widget.messageModel.senderId!,
                  messageId: widget.messageModel.messageId!)
              : chatController.getGroupReacts(
                  groupId: widget.groupModel.groupId!,
                  messageId: widget.messageModel.messageId!),
          builder: (context, snapshot) {
            return Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                widget.baseMessage
                    .messageItem(messageModel: widget.messageModel),
                Builder(builder: (context) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return InkWell(
                        onTap: () {
                          showAllReacts(
                              reacts: snapshot.data!,
                              chatController: chatController);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                chatController.reactsList[snapshot
                                    .data![snapshot.data!.length - 1]
                                    .reactType!],
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              if (snapshot.data!.length > 1)
                                Text(
                                  '${snapshot.data!.length}',
                                  style: TextStyle(
                                    color: AppColors.greyColor,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            );
          },
        ),
      );
    } else {
      return DeletedMessageItem(
        time: widget.messageModel.time!,
        senderId: widget.messageModel.senderId!,
      );
    }
  }

  Widget buildDateTimeItem({
    required MessageModel messageModel,
    required MessageModel prevMessageModel,
  }) {
    if (prevMessageModel.dateMonthYear == null ||
        messageModel.dateMonthYear != prevMessageModel.dateMonthYear) {
      return DisplayDateTimeItem(dateTime: messageModel.dateMonthYear!);
    } else {
      return const SizedBox.shrink();
    }
  }
}
