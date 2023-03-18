// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/view/components/custom_button.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: appBar,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  'Enter Your Phone Number',
                  style: TextStyle(color: AppColors.textColor, fontSize: 27),
                ),
                SizedBox(
                  height: Get.height * 0.06,
                ),
                Text(
                  'WhatsApp will need to Verify your phone number.',
                  style: TextStyle(color: AppColors.textColor),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                TextButton(
                  onPressed: () => authController.pickCountry(context),
                  child: Text('Picked Country'),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    if (authController.country != null)
                      Text(
                        authController.country!.flagEmoji,
                        style: TextStyle(color: AppColors.greyColor),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (authController.country != null)
                      Text(
                        '+${authController.country!.phoneCode}',
                        style: TextStyle(color: AppColors.textColor),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Form(
                      key: formKey,
                      child: CustomTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          isCenter: false,
                          hint: 'phone number',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please , enter your phone number !';
                            } else if (authController.country == null) {
                              return 'Please , pick or choose your country !';
                            } else {
                              return null;
                            }
                          }),
                    )),
                  ],
                ),
                SizedBox(height: Get.height * 0.1),
                Builder(builder: (context) {
                  if (authController.signInState == LoadState.loading) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return CustomButton(
                        text: 'NEXT',
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              authController.country != null) {
                            authController.signInWithPhone(
                                phoneNumber:
                                    '+${authController.country!.phoneCode}${phoneController.text.trim()}');
                          }
                        });
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          )),
    ),
  );
}
