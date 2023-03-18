import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/models/user_model.dart';

import '../../core/constants/colors.dart';

class ContactInformationScreen extends StatelessWidget {
   ContactInformationScreen({super.key, required this.contactUserModel});

  final UserModel contactUserModel ;

  @override
  Widget build(BuildContext context) {
 
    
   
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: appBar ,
      body: Padding(
        padding:
             EdgeInsets.only(bottom: 20, left: 20, right: 20, 
             top: Get.height * 0.050 ),
        child: Container(
          alignment: Alignment.center ,
          child: Column(
            children: [
              
 
              CircleAvatar(radius: 70, backgroundImage: NetworkImage(contactUserModel.profileImage!)),
              const SizedBox(height: 20),
              Text( contactUserModel.name!.toUpperCase() ,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.greyWhiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 27)),
              const SizedBox(height: 15),
              Text( contactUserModel.phoneNumber! ,
                  style: TextStyle(
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 20)),
                      const SizedBox(height: 40),

                      Text( contactUserModel.bio! ,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.greyWhiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }


   final appBar = AppBar(
    elevation: 0 ,
    title: const Text('details' , style: TextStyle(color: AppColors.tabColor )),
    centerTitle: true ,
    leading: IconButton(onPressed: (){
      Get.back();
    } , icon: const Icon(Icons.arrow_back_ios) ,
        
     ) ,
     backgroundColor: AppColors.mainColor ,
   );
}
