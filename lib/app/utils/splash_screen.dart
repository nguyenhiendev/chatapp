import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: Get.width * 0.7,
            height: Get.height * 0.7,
            child: Lottie.asset("assets/lottie/welcome.json"),
          ),
        ),
      ),
    );
  }
}
