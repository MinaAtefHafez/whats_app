
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/components/display_video_status_item.dart';
import 'package:whats_app/view/controllers/status_controller.dart';

class ConfirmStatusScreen extends StatelessWidget {

  File file ; 
  String fileType ;
  ConfirmStatusScreen({required this.file , required this.fileType});

  TextEditingController textEditingController = TextEditingController () ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(
      builder: (statusController) {
              return Scaffold(
              appBar: AppBar(
        elevation: 0.0 ,
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
              onPressed: (){
              Get.back();
        } , icon: const Icon(Icons.arrow_back_ios , color: AppColors.textColor)),
        systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColors.mainColor
        ),
      ),
       backgroundColor: AppColors.mainColor,
       body: Column(
        children: [
              buildFileItem(fileType: fileType, file: file),
              buildBottomChatBar(
                send: () {
                  statusController.addStatus(text: textEditingController.text.trim());
              }),
              
        ],
       ),
    );
    } );
  }


  Widget buildFileItem ({
      required String fileType ,
      required File file
  }) 
  {
       if ( fileType == 'image' ) {
        return Expanded(child: Image.file(file, fit: BoxFit.cover, ));
       } else {
        return Expanded(child: DisplayVideoStatusItem(videoFile: file,));
       }
  }

  
  Widget buildBottomChatBar ({
    required Function () send
  }) 
  {
    return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: send ,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: AppColors.tabColor ,
                      shape: BoxShape.circle ,
                    ),
                    child: const Icon(Icons.send , color: AppColors.textColor , size: 30 , ),
                  ),
                ),
                const SizedBox(width: 10 ,) ,
                Expanded(
                  child: Container(
                    height: 50 ,
                    child: CustomTextFormField(
                      controller: textEditingController ,
                      hint: 'Type a description . . .' , 
                       isCenter: false ,
                        keyboardType:  TextInputType.text 
                        ),
                  ),
                ),
              ],
            ),
          );
  }


 
}