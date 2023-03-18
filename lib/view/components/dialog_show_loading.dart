

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';

void dialogToShowLoading ({
  required String showText
}) {
          Get.defaultDialog(
            backgroundColor: AppColors.appBarColor ,
            title: showText ,
            titleStyle:  TextStyle( color: AppColors.greyColor , fontSize: 14  ),
            content: const CircularProgressIndicator(color: AppColors.tabColor),         
             );
    }