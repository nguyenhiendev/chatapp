import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => authC.logout(),
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                Obx(() => AvatarGlow(
                      endRadius: 110,
                      glowColor: Colors.black,
                      duration: const Duration(seconds: 2),
                      child: Container(
                          margin: const EdgeInsets.all(15),
                          width: 175,
                          height: 175,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: authC.user.value.photoUrl! == "noimage"
                                ? Image.asset("assets/logo/noimage.png",
                                    fit: BoxFit.cover)
                                : Image.network(
                                    authC.user.value.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                          )),
                    )),
                Obx(() => Text(
                      "${authC.user.value.name}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                Text(
                  "${authC.user.value.email}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                    leading: const Icon(Icons.note_add_outlined),
                    title: const Text('Update Status',
                        style: TextStyle(fontSize: 22)),
                    trailing: const Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                    leading: const Icon(Icons.person),
                    title: const Text('Change Profile',
                        style: TextStyle(fontSize: 22)),
                    trailing: const Icon(Icons.arrow_right),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.color_lens),
                    title: const Text('Change Theme',
                        style: TextStyle(fontSize: 22)),
                    trailing: const Text('Light'),
                  )
                ],
              ),
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Chat App', style: TextStyle(color: Colors.black54)),
                Text('v.1.0', style: TextStyle(color: Colors.black54))
              ],
            ),
          )
        ],
      ),
    );
  }
}
