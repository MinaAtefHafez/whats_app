import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';

void showSnackBar({
  required String title,
  required String message,
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: AppColors.tabColor,
    colorText: AppColors.textColor,
    duration: const Duration(seconds: 5),
    padding: const EdgeInsets.all(15),
    snackPosition: SnackPosition.BOTTOM,
  );
}
