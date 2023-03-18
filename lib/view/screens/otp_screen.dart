// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  String verificationId;
  OtpScreen({required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: appBar,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                ),
                const Text(
                  'Verifying your number',
                  style: TextStyle(color: AppColors.textColor, fontSize: 30),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                const Text(
                  'we have sent an SMS with a code',
                  style: TextStyle(color: AppColors.textColor),
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                Builder(builder: (context) {
                  if (authController.verifyOtpState == LoadState.loading) {
                    return Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      width: Get.width * 0.5,
                      child: CustomTextFormField(
                        keyboardType: TextInputType.number,
                        isCenter: true,
                        hint: '-   -   -   -   -   -',
                        onChanged: (value) {
                          if (value.length == 6) {
                            authController.verifyOtp(
                                verificationId: verificationId,
                                smsCode: value.toString().trim());
                          }
                        },
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  AppBar appBar = AppBar(
    elevation: 0.0,
    backgroundColor: AppColors.mainColor,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          )),
    ),
  );
}
