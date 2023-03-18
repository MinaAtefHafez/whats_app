





// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace, library_prefixes


import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app/core/agora/agora_config.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/call_model.dart';
import 'package:whats_app/view/controllers/call_controller.dart';

class CallScreen extends StatefulWidget {
  bool isGroup ;
  CallModel callModel ;
 
   CallScreen({
   required this.isGroup,
   required this.callModel
  });
  
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
   
    int remoteUid = 0 ;
     RtcEngine? engine ;

     Future <void> initAgora () async{
       await [Permission.camera , Permission.microphone].request();
      
      engine = await RtcEngine.create(AgoraConfig.appId );
        await engine!.enableVideo ();
        await engine!.enableAudio(); 
        engine!.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
         
          setState(() {
            
          });
        },
        userJoined: (int uid, int elapsed) {
          
          setState(() {
            remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
         
          setState(() {
            remoteUid = 0;
          });
          Get.back();
        },
      ),
    );
       
    await engine!.joinChannel(AgoraConfig.token, AgoraConfig.channelName , null , 0);     
     setState(() {});
     
  }

   @override
  void initState()  {
    super.initState();   
     initAgora();
    
  }

  

  @override
  void dispose() {
    super.dispose();
    engine!.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(builder: (callController) {
       return Scaffold(
       body:  SafeArea(
         child: Builder(
          builder: (_) {
             if ( engine != null ) {
                return Stack(
                  alignment: Alignment.topLeft,
                  children: [ 
                     showRemoteVideoItem(), 
                     showLocalVideoItem(),
                    ])  ;
             } else {
               return waitingToVideoCallInitItem(); 
             }
         })
       ) ,
    );
    } );
  }

   Widget showRemoteVideoItem() {
    if ( remoteUid != 0) {
      return RtcRemoteView.SurfaceView (uid: remoteUid,
      channelId: AgoraConfig.appId);
    } else 
    {
      return waitingToOtherPersonJoinToChannel ();
    }
  }


   Widget showLocalVideoItem () {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: 150 ,
        height: 150 ,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(150.0) ,
        ),
        child: const RtcLocalView.SurfaceView()),
    );
   }

   Widget waitingToVideoCallInitItem () {
      return Container(
                    alignment: Alignment.center,
                  color: AppColors.mainColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: [
                      Container(
                        width: Get.width * 0.7 ,
                        child: FittedBox(
                          alignment: Alignment.center,
                          child: Text('waiting to connect ...' , style: TextStyle( color: AppColors.greyWhiteColor )))),
                          const SizedBox(height: 15 ,),
                         const CircularProgressIndicator(color: AppColors.tabColor,)
                    ],
                  )
                );
   }

   Widget waitingToOtherPersonJoinToChannel () {
    return GetBuilder<CallController>(builder: (callController) {
             return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: AppColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.35 ,
              child:  FittedBox(
                alignment: Alignment.center,
                child: Text(
                  'Calling ... ',
                  style: TextStyle(color: AppColors.greyWhiteColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
             
             SizedBox(height: Get.height * 0.1 ) ,

             InkWell(
              onTap: () {
                 callController.endCall(receiverId: widget.callModel.receiverId);
                 Get.back();
              } ,
               child: const CircleAvatar(
                backgroundColor: AppColors.redAccent,
                radius: 30 ,
                child: Icon(Icons.call_end , size: 30),
                         ),
             ),

          ],
        ),
      );
      } );
   }

}