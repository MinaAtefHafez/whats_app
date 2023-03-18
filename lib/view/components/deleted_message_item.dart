

// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class DeletedMessageItem extends StatelessWidget {

  String time ;
  String senderId ;
  DeletedMessageItem({required this.time , required this.senderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:  BoxDecoration(
        color: FirebaseAuth.instance.currentUser!.uid == senderId ? AppColors.senderMessageColor
        : AppColors.messageColor ,
        borderRadius: BorderRadius.circular(10) , 
      ) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:  [
           Row(
            mainAxisSize: MainAxisSize.min,
             children: [
               Icon(Icons.delete , color: Colors.red.shade900 , size: 18   ),
              const SizedBox(width: 10 ),
              Text( senderId == FirebaseAuth.instance.currentUser!.uid ? 'You deleted this message' : 'this message deleted' , style: TextStyle(
                 color: AppColors.greyColor , fontSize: 15 , fontWeight: FontWeight.bold  )), 
             ],
           ),
           const SizedBox(height: 5 ,),
           Text(time , style: TextStyle( color: AppColors.greyColor , fontSize: 10  ), )
        ],
      ) ,
    );
  }
}