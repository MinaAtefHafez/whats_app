

// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/service_locator/service_locator.dart';
import 'package:whats_app/models/status_model.dart';
import 'package:whats_app/models/who_seen_story_model.dart';
import 'package:whats_app/view/components/snack_bar_fun.dart';
import 'package:whats_app/view/controllers/status_controller.dart';

class StatusScreen extends StatefulWidget {

  List <StatusModel> statuses ;
  
  

  StatusScreen({required this.statuses }) ;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {

  StoryController storyController = StoryController(); 
  List <StoryItem> items = [] ;
  StatusController statusController2 = StatusController(statusViewModel: serviceLocator()) ;
  bool isDispose = false ;
 

   @override
  void initState() {
    super.initState();
    initStoryPageItem() ;
     statusController2.isFirstIndex = true ;
     statusController2.statusesIndex = 0 ;
   
  }

    @override
  void dispose() {
    super.dispose();
    isDispose = true ;
    storyController.dispose();
  }

   void initStoryPageItem() {
      for ( int i = 0 ; i < widget.statuses.length ; i++ ) {
          if ( widget.statuses[i].fileType == 'image' ) {
             items.add(StoryItem.pageImage(url: widget.statuses[i].fileUrl! , controller: storyController));
          } else if ( widget.statuses[i].fileType == 'video'  ) {
            items.add(StoryItem.pageVideo( widget.statuses[i].fileUrl! , controller: storyController));
          } else {
            items.add(StoryItem.text(title: widget.statuses[i].text! , backgroundColor: AppColors.deepPurple , textStyle: const TextStyle( fontSize: 18
            , fontWeight: FontWeight.w400 , color: Colors.white 
              ) ));
          }
      }
   }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(
      builder: (statusController) {
     return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children:  [
              StoryView(
            controller: storyController,
            storyItems: items ,
            indicatorColor: AppColors.greyColor,
            inline: true ,
          
            onStoryShow: (storyItem) async {
                onStoryShow();
            } , 
            onComplete: (){
              Get.back();
              setState(() {
              });
            } ,
            
            onVerticalSwipeComplete: (direction) {
                  if ( direction == Direction.up ) { 
                    storyController.pause();
                    showWhoSeenStory();
                  } else if ( direction == Direction.down ) { 
                    Get.back();
                    storyController.play();
                  } 
              } ,
                  ),

                  Builder(
                    builder: (_) {
                    if ( widget.statuses[statusController2.statusesIndex].fileType != 'text' ) {
                      return Padding(
                    padding:  EdgeInsets.only( bottom: Get.height * 0.1 ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50 ,
                      width: double.infinity,
                      decoration:   BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        
                      ),
                      child: Text( widget.statuses[statusController2.statusesIndex].text! , style: const TextStyle( color: AppColors.textColor , 
                      fontSize: 17 , fontWeight: FontWeight.w300  ),
        
                       ),
                    ),
                  );
                    } else {
                      return Container();
                    }
                  } ),
            ],
          ) ,
        );
    });
  }


 void showWhoSeenStory () 
 {
    if ( widget.statuses[0].uId == FirebaseAuth.instance.currentUser!.uid ){
      Get.bottomSheet(
      FutureBuilder<List<WhoSeenStoryModel>>(
        future: statusController2.getWhoSeenStory(receiverId: widget.statuses[statusController2.statusesIndex].uId! ,
         statusId: widget.statuses[statusController2.statusesIndex].statusId!) ,
        builder: (context ,snapshot) {
              if ( snapshot.hasData ) {
                     if ( snapshot.data!.isNotEmpty ) {
                         return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(15),
                           child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                                Text('Views' , style: TextStyle( color: AppColors.greyColor , fontSize: 13  ), ),
                                const SizedBox(height: 20 ),
                               ListView.builder(
                                  shrinkWrap: true ,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ( _ ,index) {
                                        return personStorySeenItem(imageUrl: snapshot.data![index].profilePic! ,
                                         name: snapshot.data![index].userName! ,
                                         time: snapshot.data![index].time!
                                         );
                                } ),
                             ],
                           ),
                         );
                     } else {
                        return Container();
                     }
              } else {
                return Container();
              }
      } ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
     clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: AppColors.appBarColor,
    );
    }
  }
   
 Widget personStorySeenItem ({
  required String imageUrl ,
  required String name ,
  required String time
 }) 
 {
       return Row(
        children: [
          CircleAvatar(
            radius: 22 ,
            backgroundImage: CachedNetworkImageProvider(imageUrl) ,
          ),
          const SizedBox(width: 8 ,) ,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                 Text( name , style: TextStyle( color: AppColors.greyWhiteColor , fontSize: 16 , fontWeight: FontWeight.w500  )),
                 const SizedBox(height: 5 ,),
                 Text( time , style: TextStyle( color: AppColors.greyColor , fontSize: 13 )),
             ],
          ),
        ],
       );
   } 
   

 void onStoryShow () async
   {
      bool isSeenStory = false ;
     if ( statusController2.statusesIndex < widget.statuses.length - 1 && !statusController2.isFirstIndex ) { 
                  statusController2.statusesIndex ++ ; 
                   
                 }

                 if ( statusController2.statusesIndex < widget.statuses.length && !isDispose && !statusController2.isFirstIndex ) { 
                       setState(() {});
                
                 } 
                     statusController2.isFirstIndex = false ;
                 var whoSeen = await FirebaseFirestore.instance.collection('users').doc(widget.statuses[0].uId).collection('status')
                    .doc(widget.statuses[statusController2.statusesIndex].statusId).collection('whoSeen').get();

                     for ( int i = 0 ; i < whoSeen.docs.length ; i++ ) {
                         if ( whoSeen.docs[i].id == FirebaseAuth.instance.currentUser!.uid ) {
                            isSeenStory = true ; 
                         }
                     }
                
                if ( statusController2.statusesIndex < widget.statuses.length ){
                    if ( !isSeenStory ) {
                      await statusController2.setStorySeen(
                        receiverId: widget.statuses[0].uId! ,
                  statusId: widget.statuses[statusController2.statusesIndex].statusId! );      
                  await statusController2.changeStorySeen(
                    receiverId: widget.statuses[0].uId! , 
                     statusId:  widget.statuses[statusController2.statusesIndex].statusId! 
                   );
                    }
                } 
   }
}
