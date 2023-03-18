// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/view/components/custom_button.dart';
import 'package:whats_app/view/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:  EdgeInsets.only(right: Get.width * 0.01 , left:  Get.width *0.01 ),
        height: double.infinity,
        width: double.infinity,
        color: AppColors.mainColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.1, bottom: Get.height * 0.1),
              child: Container(
                alignment: Alignment.center,
                width: Get.width *0.9 ,
                child: const Text(
                  'Welcome to WhatsApp',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Image.network(
                  AppConstants.landingImageUrl ,
                  height: 340,
                  width:  Get.width *0.8 ,
                  color: AppColors.tabColor,
                )),
            SizedBox(
              height: Get.height * 0.1,
            ),
            Padding(
              padding:  EdgeInsets.symmetric( horizontal: Get.width * 0.01  ),
              child: Text(
                'Read our Privacy Policy Tap "Agree and continue" to accept the Terms of Service',
                style: TextStyle(color: AppColors.greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () {
                  Get.to(() => LoginScreen());
                }),
          ],
        ),
      ),
    );
  }
}
