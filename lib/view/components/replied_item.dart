// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/view/components/display_video_item.dart';

class RepliedItem extends StatefulWidget {
  MessageModel messageModel;
  
  RepliedItem(
      {
      required this.messageModel,
   
      });

  @override
  State<RepliedItem> createState() => _RepliedItemState();
}

class _RepliedItemState extends State<RepliedItem> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (isReplied) {
      return Container(
        padding:
            const EdgeInsets.only(left: 1.5, right: 1.5, top: 2, bottom: 0.8),
        decoration: BoxDecoration(
          color: AppColors.searchBarColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 7),
          decoration: BoxDecoration(
            color: AppColors.chatBarColor,
            borderRadius: BorderRadius.circular(15), 
          ),
          child: repliedToggleItem(
              messageModel: widget.messageModel),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget repliedText({
    required String text,
    required String senderId
  })
   {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              senderId == auth.currentUser!.uid
                  ? 'You'
                  : widget.messageModel.senderName!,
              style: const TextStyle(
                  color: AppColors.deepPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  isReplied = false;
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.greyColor,
                  size: 19,
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 13, bottom: 5),
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textColor, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget repliedImage({
    required String imageUrl,
    required String senderId
  }) 
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderId == auth.currentUser!.uid
                      ? 'You'
                      : widget.messageModel.senderName!,
                  style: const TextStyle(
                      color: AppColors.deepPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Stack(
          children: [
            Container(
              height: 80,
              width: 70,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 35,
              child: IconButton(
                  onPressed: () {
                    isReplied = false;
                    setState(() {});
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                          color: AppColors.greyColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyWhiteColor,
                        size: 19,
                      ))),
            )
          ],
        ),
      ],
    );
  }

  Widget repliedVideo({required String videoUrl , 
  required String senderId}) 
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderId == auth.currentUser!.uid
                      ? 'You'
                      : widget.messageModel.senderName!,
                  style: const TextStyle(
                      color: AppColors.deepPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Stack(
          children: [
            Container(
              height: 80,
              width: 70,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: DisplayVideoItem(videoUrl),
            ),
            Positioned(
              bottom: 40,
              left: 35,
              child: IconButton(
                  onPressed: () {
                    isReplied = false;
                    setState(() {});
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                          color: AppColors.greyColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyWhiteColor,
                        size: 19,
                      ))),
            )
          ],
        ),
      ],
    );
  }

  Widget repliedRecord({required String senderId}) 
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              senderId == auth.currentUser!.uid ? 'You' : widget.messageModel.senderName!,
              style: const TextStyle(
                  color: AppColors.deepPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.audiotrack,
            color: Colors.deepPurple,
            size: 18,
          ),
          Icon(
            Icons.audiotrack_outlined,
            color: Colors.deepOrange,
            size: 18,
          ),
         const SizedBox(width: 10 ,) ,
          Text(
            'voice',
            style: TextStyle(
                color: AppColors.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
         const SizedBox(width: 15 ,) ,
         InkWell(
          onTap: (){
            isReplied = false ;
            setState(() {});
          } ,
          child: Icon(Icons.close , color: AppColors.greyColor ,  size: 17 , )),
        ],
      ),
    );
  }

  Widget repliedToggleItem(
      {required MessageModel messageModel}) 
      {
    switch (messageModel.type) {
      case 'text':
        return repliedText(text: messageModel.text! , senderId: messageModel.senderId! );
      case 'image':
        return repliedImage(imageUrl: messageModel.fileUrl! , senderId: messageModel.senderId!);
      case 'video':
        return repliedVideo(videoUrl: messageModel.fileUrl!, senderId: messageModel.senderId! );
      default:
        return repliedRecord(senderId: messageModel.senderId!);
    }
  }
}
