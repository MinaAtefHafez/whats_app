



// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/models/status_model.dart';
import 'package:whats_app/view/components/dialog_show_loading.dart';
import 'package:whats_app/view/controllers/status_controller.dart';
import 'package:whats_app/view/screens/confirm_text_status_screen.dart';
import 'package:whats_app/view/screens/status_screen.dart';

class StatusContactsScreen extends StatefulWidget {

  @override
  State<StatusContactsScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(builder: (statusController) {
      return Builder(
        builder: (context) {
          SchedulerBinding.instance.addPostFrameCallback((_){
            if ( statusController.upLoadStatusState == LoadState.loading ) {
            dialogToShowLoading(showText: 'status uploading ...' );
          } else {
            Get.back();
            Get.back();
          }
          });
          return Scaffold(
               backgroundColor: AppColors.mainColor, 
    floatingActionButton: Column( 
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
              heroTag: '1' ,
              onPressed: () {
                  showDialogConfirmStatus(
                    chooseImage: () {
                      statusController.pickedImage();
                    } , 
                  chooseVideo: () {
                    statusController.pickedVideo();
                  } );
    } ,
     backgroundColor: AppColors.tabColor,
     child: const Icon(Icons.image),
    ),
       const SizedBox( height: 30 ),
       
       FloatingActionButton(
              heroTag: '2' ,
              onPressed: () {
                Get.to(()=> ConfirmTextStatusScreen() );
    } ,
     backgroundColor: AppColors.tabColor,
     child: const Icon(Icons.auto_fix_high_outlined),
    ),
      ],
    ),
       body: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
         children: [
                 listenToMyStatusesItem(statusController: statusController),
                 Padding(
                   padding: const EdgeInsets.symmetric( horizontal: 20  , vertical: 10  ),
                   child: Container(
                    height: 1 ,
                    width: double.infinity,
                    color: Colors.grey.shade800,
                   ),
                 ),
            
                  Builder(
                    builder: (context) {
                      return Padding(
                       padding: const EdgeInsets.symmetric (horizontal: 20 , vertical: 5   ),
                       child: Text('Your Statuses' , style: TextStyle( color: AppColors.greyColor , fontSize: 15 , fontWeight: FontWeight.w400  )),
                 );
                    }
                  ),
               listenToStatusesItem(statusController: statusController),
         ],
       ),
         );
        }
      );
    } );
    
  }

  
  void showDialogConfirmStatus ({
    required Function () chooseImage,
    required Function () chooseVideo,
  }) 
  {
    Get.defaultDialog(
      title: 'Choose File Type ?' ,
      titleStyle: const TextStyle( color: AppColors.textColor , fontSize: 15  ) ,
       contentPadding: const EdgeInsets.all(10),
       backgroundColor: AppColors.appBarColor, 
       content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
             children: [
              InkWell(
                onTap: chooseImage ,
                child: Column(
                  children: [
                     const Icon(Icons.image , color: AppColors.tabColor ,  size: 35 , ),
                     Text('Image' , style: TextStyle( color: AppColors.greyColor , fontSize: 11  , fontWeight: FontWeight.w300 ), ) ,
                  ],
                ),
              ),
              const SizedBox( width: 80 ),
              InkWell(
                onTap: chooseVideo ,
                child: Column(
                  children: [
                     const Icon(Icons.video_camera_back_outlined , color: AppColors.tabColor ,  size: 35 , ),
                     Text('Video' , style: TextStyle( color: AppColors.greyColor , fontSize: 11 , fontWeight: FontWeight.w300 ), ) ,
                  ],
                ),
              ),
             ],
       ),
    );
  }


  
 Widget storyContactItem ({ 
  required String imageUrl ,
  required String userName ,
  required String time ,
  required bool isStorySeen ,
  required bool isMe
 }) 
 {
       return Row(
          children: [
            CircleAvatar(
              radius: 31 ,
              backgroundColor: isStorySeen ? AppColors.greyColor : AppColors.tabColor  ,
              child: CircleAvatar(
                radius: 28 ,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
              ),
            ),
            const SizedBox(width: 15 ,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName , style:  TextStyle( color: isMe ? AppColors.deepPurple : Colors.white , fontSize: 17 , fontWeight: FontWeight.bold  ), ),
                const SizedBox(height: 5 ,),
                Text( time , style: TextStyle( color: AppColors.greyColor , fontSize: 12 )),
               ],
            )
          ],
       );
  }


  bool isStorySeen ({
   required List <StatusModel> list
  })
   {
     bool isStorySeen = true ;
     List <bool> boolList = [];
                  for ( int i = 0 ; i < list.length  ; i++ ) {
                    bool isMyIdExist = false ;
                         for ( int j = 0 ; j < list[i].isSeen!.length ; j++ ) {
                             if ( list[i].isSeen![j].isNotEmpty ) {
                                  if ( list[i].isSeen![j] == FirebaseAuth.instance.currentUser!.uid ) {
                                   isMyIdExist = true ;
                                   boolList.add(true);
                             } else if ( j == list[i].isSeen!.length - 1 && !isMyIdExist  ) {
                                  boolList.add(false);
                             }
                             }  

                         }

                  }

                  if ( boolList.isNotEmpty ) {
                    for ( int i = 0 ; i < boolList.length ; i++ ) {
                      if ( boolList[i] == false ) {
                        isStorySeen = false ;
                      } 
                  }
                  } else {
                    isStorySeen = false ;
                  }
            return isStorySeen ;
  }

   
   Widget listenToMyStatusesItem ({
     required StatusController statusController
   })
    {
    return FutureBuilder<List<StatusModel>>(
      future: statusController.getMyStatuses() ,
      builder: (_ , snapshot) {
          if ( snapshot.hasData ) {
            if ( snapshot.data!.isNotEmpty ) {
                  return InkWell(
                    onTap: (){
                        Get.to( ()=> StatusScreen(statuses: snapshot.data!  ));
                    } ,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: storyContactItem(
                        imageUrl: snapshot.data![0].profilePic! , 
                         userName: 'My Status' , 
                          time: snapshot.data![0].time! , 
                           isStorySeen: isStorySeen(list: snapshot.data!),
                           isMe: true 
                           ),
                    ),
                  );
            } else {
                 return Container();
            }

          } else if ( snapshot.connectionState == ConnectionState.waiting ) {
            return Container(
              height: 100 ,
              alignment: Alignment.center ,
              child: const CircularProgressIndicator(color: AppColors.tabColor,),
             );
          } else {
            return Container(); 
          }
      },
      );
   }

    Widget listenToStatusesItem ({
      required StatusController statusController
    })
     {
      return FutureBuilder<List<List<StatusModel>>>(
            future: statusController.getStatuses() ,
            builder: ((context, snapshot) {
                if ( snapshot.hasData ) {
                     if ( snapshot.data!.isNotEmpty ) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: ( _ , index ) {
                             bool isForMe = isStatusesForMe(statusModel: snapshot.data![index][0] );
                                if ( isForMe ) {
                                  return   InkWell(
                                  onTap: (){
                                    Get.to( ()=> StatusScreen(statuses: snapshot.data![index] ,  ));
                                  } ,
                                  child: storyContactItem(imageUrl: snapshot.data![index][0].profilePic! ,
                                         userName: snapshot.data![index][0].userName! ,
                                         time: snapshot.data![index][0].time! ,
                                         isStorySeen: isStorySeen(list: snapshot.data![index] ),
                                         isMe: false 
                                       ),
                                );
                                } else {
                                  return Container() ;
                                }
                                 
                            },
                            itemCount: snapshot.data!.length ,
                            separatorBuilder: (context , index) {
                              return const SizedBox( height: 15 , ); 
                            } ,
                             ),
                          );      
                     } else {
                      return  Container();
                     }
                } else if ( snapshot.connectionState == ConnectionState.waiting ) {
                  return  const Center(child: CircularProgressIndicator(color: AppColors.tabColor,)) ;
                } else {
                  return Container();
                }
               }) );
    }

   bool isStatusesForMe ({
    required StatusModel statusModel
   }) 
   {
       bool isForMe = false ;
       for ( int i = 0 ; i < statusModel.whoCanSee!.length ; i++ ) {
              if ( statusModel.whoCanSee![i] == FirebaseAuth.instance.currentUser!.uid ) {
                   isForMe = true ;
              }
       }
       return isForMe ;
   }


}