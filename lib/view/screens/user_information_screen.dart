// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/core/constants/constants.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/controllers/auth_controller.dart';

class UserInformationScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.15, horizontal: Get.width * 0.06),
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      authController.profileImage == null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  AppConstants.defaultUserImageUrl))
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  FileImage(authController.profileImage!),
                            ),
                      Positioned(
                        left: 80,
                        bottom: -10,
                        child: IconButton(
                            onPressed: () {
                              authController.pickImageFromGallery();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.tabColor,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: CustomTextFormField(
                            controller: nameController,
                            hint: 'name',
                            isCenter: false,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please , enter your name';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Builder(builder: (context) {
                        if (authController.saveDataFireStoreState ==
                            LoadState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return IconButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  authController.saveUserDateToFirebase(
                                      name: nameController.text.trim(),
                                    );
                                }
                              },
                              icon: const Icon(
                                Icons.done,
                                color: AppColors.textColor,
                                size: 35,
                              ));
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
