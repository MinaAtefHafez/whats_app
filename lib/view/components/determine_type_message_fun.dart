

import 'package:whats_app/core/service_locator/service_locator.dart';
import 'package:whats_app/view/components/type_class_message.dart';

BaseMessage determineMessageType ({
    required String messageType , 
      String? repliedMessageType ,
   }) {
         
         BaseRepliedMessage repliedMessage ;

         switch (repliedMessageType) {
          case 'text' : repliedMessage = RepliedTextMessage(serviceLocator()) ; break  ;  
          case 'image' : repliedMessage = RepliedImageMessage(serviceLocator()) ; break ;
          case 'video' : repliedMessage  = RepliedVideoMessage(serviceLocator()) ; break ;
          default : repliedMessage = RepliedAudioMessage(serviceLocator());
         }
       
      switch (messageType) {
        case 'text' : return TextMessage(serviceLocator() ,repliedMessage );
        case 'image' : return ImageMessage(serviceLocator() , repliedMessage );
        case 'video' : return VideoMessage(serviceLocator() , repliedMessage);
        default : return AudioMessage(serviceLocator() , repliedMessage);
      }
   }


