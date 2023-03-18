




// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/call_model.dart';
import 'package:whats_app/view/controllers/call_controller.dart';
import 'package:whats_app/view/screens/call_screen.dart';

class CallReceivedItem extends StatelessWidget {
  
  CallModel callModel ;
  bool isGroup ;
  CallReceivedItem ({ required this.callModel , required this.isGroup });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(builder: (callController) {
         return SafeArea(
        child: Scaffold(
          body: Stack(
              children: [
                Container(
                  color: AppColors.mainColor ,
                ),
        
               Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min ,
                  children: [
                    Container(
                      width: Get.width * 0.4 ,
                      height: 40 ,
                      child: FittedBox(
                        alignment: Alignment.center,
                        child: Text('Incoming Call' , style: TextStyle( color: AppColors.greyWhiteColor ) , )),
                    ) ,
                    const SizedBox( height: 40 ),
                     CircleAvatar(
                      radius: 60 ,
                      backgroundImage: NetworkImage(callModel.callerPic),
                     ),
                     const SizedBox( height: 20),
                     Container(
                      width: Get.width * 0.5 ,
                      
                      child: FittedBox(
                        alignment: Alignment.center,
                        child: Text(callModel.callerName, style:  TextStyle( color: AppColors.greyWhiteColor , fontWeight: FontWeight.bold  ) , )),
                    ) ,

                    const SizedBox(height: 60 ) ,
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                        children: [
                          InkWell(
                            onTap: (){
                                  Get.to(() => CallScreen(isGroup: isGroup ,   
                                  callModel: callModel,  ) );
                            } ,
                            child: CircleAvatar(
                              radius: 35 ,
                              backgroundColor: AppColors.tabColor,
                              child: Icon(Icons.call , color: AppColors.greyWhiteColor, size: 30 , )  ,
                            ),
                          ),
                              
                              
 
                          InkWell(
                            onTap: (){
                              callController.endCall(receiverId: callModel.callerId );
                            } ,
                            child: CircleAvatar(
                              radius: 35 ,
                              backgroundColor: AppColors.redAccent,
                              child: Icon(Icons.call_end , color: AppColors.greyWhiteColor, size: 30 , )  ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                 ),
               ),
              ],
          ),
        ),
       
       );
    } );
  }
}