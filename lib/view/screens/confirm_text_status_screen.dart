





// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/view/controllers/status_controller.dart';

class ConfirmTextStatusScreen extends StatefulWidget {
  
  @override
  State<ConfirmTextStatusScreen> createState() => _ConfirmTextStatusScreenState();
}

class _ConfirmTextStatusScreenState extends State<ConfirmTextStatusScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) { 
    return GetBuilder<StatusController>(builder: (statusController) {
      return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20 , vertical: 2  ),
        color: AppColors.deepPurple,
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.25 ),
        Expanded(
          child: TextFormField(
                 controller: textController,
                decoration:  InputDecoration(
                    border: InputBorder.none ,
                    hintText: 'Write Your Story' , 
                    hintStyle: TextStyle( color: AppColors.greyWhiteColor , fontSize: 30 , fontWeight: FontWeight.w600  ),
                    
                  ),
                   autofocus: true ,
                   cursorColor: Colors.black ,
                   cursorHeight: 40 ,
                   textAlign: TextAlign.center,
                   maxLines: 10 ,
                   style: const TextStyle(color: Colors.black , fontSize: 27  ),
                      onChanged: ((value) {
                          setState(() {});
                      }) ,
                      ),
        ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            height: 100 ,
            color: Colors.black.withOpacity(0.3) ,
            child: textController.text.isNotEmpty ? InkWell(
              onTap: (){
                  statusController.addTextStatus(text: textController.text.trim());
              } ,
              child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.tabColor,
                  child:  Icon(
                         Icons.send,
                    color: AppColors.textColor,
                    textDirection: TextDirection.rtl,
                    size: 33,
                  )),
            ) : Container() , 
          ),
           ],
        ), 
      ),
      
    );
    } );
  }
}