// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whats_app/view/screens/home_screen.dart';
import 'package:whats_app/view/screens/landing_screen.dart';
import 'package:whats_app/view/screens/user_information_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 4), () {
      if (GetStorage().read('isAuthEnd') != null) {
        Get.off(() => HomeScreen());
      } else if (GetStorage().read('isVerify') != null) {
        Get.off(() => UserInformationScreen());
      } else {
        Get.off(() => LandingScreen());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash_screen.jpeg',
            fit: BoxFit.fill,
          )),
    );
  }
}
