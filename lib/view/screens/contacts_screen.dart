// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/view/controllers/home_controller.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: AppColors.mainColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: ()  {
                    homeController.selectContactToChat(
                        selectContact: homeController.contacts[index]);
                  },
                  child: buildContactItem(
                      contact: homeController.contacts[index]));
            },
            itemCount: homeController.contacts.length,
          ),
        ),
      );
    });
  }

  AppBar appBar = AppBar(
    elevation: 0.0,
    centerTitle: true,
    title: const Text(
      'Select contact',
      style: TextStyle(color: AppColors.textColor, fontSize: 23),
    ),
    backgroundColor: AppColors.searchBarColor,
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
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
    ],
  );

  Widget buildContactItem({
    Contact? contact,
  })
   {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          contact!.photo != null
              ? CircleAvatar(
                  radius: 40,
                  backgroundImage: MemoryImage(contact.photo!),
                )
              : Container(),
          const SizedBox(
            width: 10,
          ),
          Text(
            contact.displayName,
            style: const TextStyle(color: AppColors.textColor, fontSize: 18),
          )
        ],
      ),
    );
  }
}
