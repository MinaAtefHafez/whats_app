



import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/last_message_model.dart';
import 'package:whats_app/models/message_model.dart';
import 'package:whats_app/view/components/audio_item.dart';
import 'package:whats_app/view/components/display_video_item.dart';

abstract class BaseMessage {
  BaseMessage ({required this.auth , required this.baseRepliedMessage });
  FirebaseAuth auth ;
  BaseRepliedMessage baseRepliedMessage ;
  
  Widget messageItem ({required MessageModel messageModel}) ;

  Widget typeLastMessageHomeChatItem ({
    required LastMessageModel lastMessageModel ,
    required TextStyle customTextStyle
  }) ;
}


class TextMessage implements BaseMessage {

   TextMessage (this.auth , this.baseRepliedMessage);

  @override
  FirebaseAuth auth;

  @override
  BaseRepliedMessage baseRepliedMessage ;

   
  @override
  Widget messageItem({required MessageModel messageModel}) {
    
    return Padding(
      padding:  const EdgeInsets.only( bottom: 23 , left: 8 , top: 5 , right:  5   ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ( messageModel.repliedId != '' )
         baseRepliedMessage.repliedMessageItem(messageModel: messageModel),
          const SizedBox(
            height: 5,
          ),
          Text(
            messageModel.text!,
            style: const TextStyle(color: AppColors.textColor),
            textAlign: TextAlign.end,
          ),
          const SizedBox(
            height: 5,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageModel.time!,
                style: TextStyle(color: AppColors.greyColor, fontSize: 10),
              ),
              const SizedBox(
                width: 8,
              ),
              if ( auth.currentUser!.uid == messageModel.senderId )
              Icon(
                Icons.done_all,
                color: messageModel.isSeen!
                    ? AppColors.blueColor
                    : AppColors.greyWhiteColor,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  
  @override
  Widget typeLastMessageHomeChatItem({
    required LastMessageModel lastMessageModel ,
    required TextStyle customTextStyle 
  }) 
  {
     return Text(
                    lastMessageModel.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle
                  );
  }
  
 
  
  
  


}

class ImageMessage implements BaseMessage {

  ImageMessage(this.auth , this.baseRepliedMessage);
  @override
  FirebaseAuth auth;

  @override
  BaseRepliedMessage baseRepliedMessage ;

  

  @override
  Widget messageItem({required MessageModel messageModel}) {
    return Padding(
      padding: const EdgeInsets.only( bottom: 23 , left: 5 , top: 5 , right:  5   ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ( messageModel.repliedId != '' )
          baseRepliedMessage.repliedMessageItem(messageModel: messageModel),
          const SizedBox(
            height: 5,
          ),
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: messageModel.fileUrl!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageModel.time!,
                style: TextStyle(color: AppColors.greyColor, fontSize: 10),
              ),
              const SizedBox(
                width: 8,
              ),
              if ( auth.currentUser!.uid == messageModel.senderId )
              Icon(
                Icons.done_all,
                color: messageModel.isSeen!
                    ? AppColors.blueColor
                    : AppColors.greyWhiteColor,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  
  @override
  Widget typeLastMessageHomeChatItem({required LastMessageModel lastMessageModel, required TextStyle customTextStyle}) {
      return  Row(
                        children: [
                          const Icon(Icons.camera_alt, color: AppColors.tabColor, size: 15 , ) ,
                          const SizedBox(width: 5 ,) ,
                          Text(
                    'Photo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle
                  ),
                        ],
                      );
  }
  

}

class VideoMessage implements BaseMessage {

  VideoMessage(this.auth,this.baseRepliedMessage);
  @override
  FirebaseAuth auth;

  @override
  BaseRepliedMessage baseRepliedMessage ;


  @override
  Widget messageItem({required MessageModel messageModel}) {
     return Padding(
      padding: const EdgeInsets.only( bottom: 23 , left: 8 , top: 5 , right:  5     ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ( messageModel.repliedId != '' )
          baseRepliedMessage.repliedMessageItem(messageModel: messageModel),
          const SizedBox(
            height: 5,
          ),
          Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: DisplayVideoItem(messageModel.fileUrl!)),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageModel.time!,
                style: TextStyle(color: AppColors.greyColor, fontSize: 10),
              ),
              const SizedBox(
                width: 8,
              ),
              if ( auth.currentUser!.uid == messageModel.senderId)
              Icon(
                Icons.done_all,
                color: messageModel.isSeen!
                    ? AppColors.blueColor
                    : AppColors.greyWhiteColor,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Widget typeLastMessageHomeChatItem({required LastMessageModel lastMessageModel, required TextStyle customTextStyle}) {
         return Row(
                        children: [
                          const Icon(Icons.video_settings , color: Colors.deepOrange , size: 17 , ) ,
                          const SizedBox(width: 5 ,) ,
                          Text(
                    'Video',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle
                  ),
                        ],
                      );
  }
  
}

class AudioMessage implements BaseMessage {


  
  AudioMessage(this.auth, this.baseRepliedMessage);

  @override
  FirebaseAuth auth;

  @override
  BaseRepliedMessage baseRepliedMessage ;

  @override
  Widget messageItem({required MessageModel messageModel}) {
     return Padding(
      padding:  const EdgeInsets.only( bottom: 23 , left: 8 , top: 5 , right:  5   ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if ( messageModel.repliedId != '' )
          baseRepliedMessage.repliedMessageItem(messageModel: messageModel),
          AudioItem(
            audioUrl: messageModel.fileUrl!,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageModel.time!,
                style: TextStyle(color: AppColors.greyColor, fontSize: 10),
              ),
              const SizedBox(
                width: 8,
              ),
              if ( auth.currentUser!.uid == messageModel.senderId )
              Icon(
                Icons.done_all,
                color: messageModel.isSeen!
                    ? AppColors.blueColor
                    : AppColors.greyWhiteColor,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
  

  
  @override
  Widget typeLastMessageHomeChatItem({required LastMessageModel lastMessageModel, required TextStyle customTextStyle}) {
        return Row(
                        children: [
                          const Icon(Icons.audiotrack_outlined , color: Colors.deepPurple , size: 17 , ) ,
                          const SizedBox(width: 5 ,) ,
                          Text(
                    'Audio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle
                  ),
                        ],
                      );
  }
  
}


abstract class BaseRepliedMessage {
    
    BaseRepliedMessage(this.auth);

    Widget repliedMessageItem ({required MessageModel messageModel}); 
    FirebaseAuth auth ;
}

class RepliedTextMessage implements BaseRepliedMessage {
     
     RepliedTextMessage(this.auth);

     @override
      FirebaseAuth auth ;
      @override
  Widget repliedMessageItem({required MessageModel messageModel}) {
    return Container(
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: auth.currentUser!.uid == messageModel.senderId ? AppColors.repliedMyMessageColor : AppColors.repliedHisMessageColor ,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            messageModel.repliedId == auth.currentUser!.uid ? 'You' : messageModel.contactName!,
            style: const TextStyle(
                color: AppColors.deepPurple,
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            messageModel.repliedText!,
            style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class RepliedImageMessage implements BaseRepliedMessage {
  RepliedImageMessage(this.auth);

     @override
      FirebaseAuth auth ;
  
    @override
  Widget repliedMessageItem({required MessageModel messageModel}) {
      return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: auth.currentUser!.uid == messageModel.senderId ? AppColors.repliedMyMessageColor : AppColors.repliedHisMessageColor ,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageModel.repliedId == auth.currentUser!.uid ? 'You' : messageModel.contactName!,
                  style: const TextStyle(
                      color: AppColors.deepPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColors.greyColor,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'image',
                      style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 70,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CachedNetworkImage(imageUrl: messageModel.repliedFileUrl!),
          ),
        ],
      ),
    );
  }


}

class RepliedVideoMessage implements BaseRepliedMessage {
  RepliedVideoMessage(this.auth);

     @override
      FirebaseAuth auth ;
      
        @override
  Widget repliedMessageItem({required MessageModel messageModel}) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: auth.currentUser!.uid == messageModel.senderId ? AppColors.repliedMyMessageColor : AppColors.repliedHisMessageColor ,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageModel.repliedId == auth.currentUser!.uid ? 'You' : messageModel.contactName!,
                  style: const TextStyle(
                      color: AppColors.deepPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.video_call_rounded,
                      color: AppColors.greyColor,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'video',
                      style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 50,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: DisplayVideoItem(messageModel.repliedFileUrl!),
          ),
        ],
      ),
    );
  }
}

class RepliedAudioMessage implements BaseRepliedMessage {
  RepliedAudioMessage(this.auth);

     @override
      FirebaseAuth auth ;
      
        @override
        Widget repliedMessageItem({required MessageModel messageModel}) {
         return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: auth.currentUser!.uid == messageModel.senderId ? AppColors.repliedMyMessageColor : AppColors.repliedHisMessageColor ,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              messageModel.repliedId == auth.currentUser!.uid ? 'You' : messageModel.contactName!,
              style: const TextStyle(
                  color: AppColors.deepPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic,
                  color: AppColors.greyColor,
                ),
                Text(
                  'voice',
                  style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );
        }
}