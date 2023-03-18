// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final Function? validator;
  final bool isCenter  ; 
  final TextInputType? keyboardType ;
  final Function? onChanged ;

   CustomTextFormField(
      { this.controller, required this.hint,  this.validator , required this.isCenter ,  this.keyboardType  ,
       this.onChanged ,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start ,
      controller: controller,
      style: const TextStyle(color: AppColors.textColor, fontSize: 20),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 15),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.greyColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.greyColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.greyColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.greyColor)),
      ),
      validator: (value) => validator!(value),
      onChanged: (value) => onChanged!(value) ,
      cursorColor: AppColors.textColor,
      keyboardType: keyboardType,
    );
  }
}
