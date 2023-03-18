





// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text ; 
  final Function () onPressed ;

  CustomButton ({
    required this.text ,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tabColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(text , textAlign: TextAlign.center, style: const TextStyle( color: AppColors.blackColor  ), ),
      ),
    );
  }
}