// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:whats_app/core/constants/colors.dart';
import 'package:whats_app/view/controllers/home_controller.dart';
import 'package:whats_app/view/screens/create_group_screen.dart';
import 'package:whats_app/view/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
   
   

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void setUserState(bool isOnline) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isOnline': isOnline});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
         return DefaultTabController(
          length: 3 ,
           child: Scaffold(
            appBar: appBar(homeController: homeController),
            body : TabBarView(
              physics: const BouncingScrollPhysics(),
              children: homeController.homeScreens ))
         );
    } );
  }

  AppBar appBar({
   required HomeController homeController ,
  })
   {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
      elevation: 0.0,
      title: Text(
        'WhatsApp',
        style: TextStyle(color: AppColors.greyColor, fontSize: 25),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: AppColors.greyColor,
            )),
         PopupMenuButton(
          icon: Icon(Icons.more_vert , color: AppColors.greyColor, ),
          itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0 ,
                  onTap: (){} ,
                  child: const Text('Create Group' ),
                 
                 ),

                 PopupMenuItem(
                  value: 1,
                  onTap: () {} ,
                  child: const Text('Settings') )
              ];
            
         },
           onSelected: (value) {
               if ( value == 0 ) {
                Get.to(()=>  CreateGroupScreen());
               } else {
                 Get.to( () => SettingsScreen() );
               }
           } ,
           
          ),
      ],
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.appBarColor
      ) ,
      bottom: TabBar( 
        tabs: homeController.tabBarList.map((e) => Center(child: Tab(text: e)) ).toList(), 
        labelColor: AppColors.tabColor,
        indicatorColor: AppColors.tabColor,
        unselectedLabelColor: AppColors.greyColor, 
        
        ),
    );
  }

}
