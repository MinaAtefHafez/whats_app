



// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class DisplayDateTimeItem extends StatelessWidget {
 final String dateTime ;

  const DisplayDateTimeItem({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric( vertical: 10  ),
        child: Container(
          padding: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5) ,
            color: AppColors.messageColor
          ),
          child: Text( dateTime , style: TextStyle( color: AppColors.greyColor , fontSize: 11  ), ),
        ),
      ),
    );
  }
}