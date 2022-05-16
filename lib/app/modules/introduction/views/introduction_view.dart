import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:chatapp/app/routes/app_pages.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Ứng dụng miễn phí",
            body: "Bạn không cần phải lo lắng, ứng dụng này hoàn toàn miễn phí.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/hello.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "Tham gia ngay",
            body: "Đăng ký để trở thành một phần của chúng tôi.",
            image: SizedBox(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/register.json"),
              ),
            ),
          ),
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
