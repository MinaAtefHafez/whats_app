// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/models/user_model.dart';
import 'package:whats_app/view/components/custom_button.dart';
import 'package:whats_app/view/components/custom_text_form_field.dart';
import 'package:whats_app/view/controllers/setting_controller.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String textThatWillUpdate = '';
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: appBar,
      body: GetBuilder<SettingController>(builder: (settingController) {
        return FutureBuilder<UserModel>(
            future: settingController.getMySettingData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 20, right: 20, top: 50),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            settingController.settingImage == null
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.profileImage!))
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundImage: FileImage(
                                        settingController.settingImage!),
                                  ),
                            Positioned(
                              left: 80,
                              bottom: -10,
                              child: IconButton(
                                  onPressed: () {
                                    settingController.pickSettingImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.tabColor,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            showBottomSheetToUpdateSetting(
                                hint: 'write your bio ...',
                                onPressedUpdate: () {
                                  if (formKey.currentState!.validate()) {
                                    settingController
                                        .updateMyBio(textThatWillUpdate);
                                  }
                                  Get.back();
                                  setState(() {});
                                });
                          },
                          child: Text(snapshot.data!.bio!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                        ),
                        const SizedBox(height: 50),
                        buildSettingItem(
                            itemTitle: 'name',
                            detailsTitle: snapshot.data!.name!,
                            onPressed: () {
                              showBottomSheetToUpdateSetting(
                                hint: 'write a new Name ...',
                                onPressedUpdate: () {
                                  if (formKey.currentState!.validate()) {
                                    settingController
                                        .updateMyName(textThatWillUpdate);
                                  }
                                  Get.back();
                                  setState(() {});
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.tabColor,
                ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  AppBar appBar = AppBar(
    backgroundColor: AppColors.appBarColor,
    title: Text('Setting',
        style: TextStyle(color: AppColors.greyWhiteColor, fontSize: 23)),
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios)),
  );

  Widget buildSettingItem(
      {required String itemTitle,
      required String detailsTitle,
      required Function() onPressed}) {
    return ListTile(
      leading: const Icon(Icons.person),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        color: AppColors.tabColor,
        onPressed: onPressed,
      ),
      title: Text(itemTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(detailsTitle,
            style: TextStyle(
                color: AppColors.greyWhiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      iconColor: AppColors.greyColor,
      textColor: AppColors.greyColor,
    );
  }

  void showBottomSheetToUpdateSetting(
      {required String hint, required dynamic Function() onPressedUpdate}) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: CustomTextFormField(
                hint: hint,
                isCenter: false,
                onChanged: (value) {
                  textThatWillUpdate = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'field should not be empty !';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(text: 'Update', onPressed: onPressedUpdate)
          ],
        ),
      ),
      backgroundColor: AppColors.mainColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    );
  }
}
