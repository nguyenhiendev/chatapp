import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  ChangeProfileView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status!;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.blue[600],
          title: const Text('Change Proflie'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                authC.changeProfile(
                    controller.nameC.text, controller.statusC.text);
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              //Avatar
              AvatarGlow(
                endRadius: 70,
                glowColor: Colors.black,
                duration: const Duration(seconds: 1),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: 120,
                  height: 120,
                  child: Obx(() => ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: authC.user.value.photoUrl! == "noimage"
                            ? Image.asset("assets/logo/noimage.png",
                                fit: BoxFit.cover)
                            : Image.network(authC.user.value.photoUrl!,
                                fit: BoxFit.cover),
                      )),
                ),
              ),
              const SizedBox(height: 20),
              //Email
              TextField(
                controller: controller.emailC,
                readOnly: true,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              //Name
              TextField(
                controller: controller.nameC,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              //Status
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  authC.changeProfile(
                      controller.nameC.text, controller.statusC.text);
                },
                decoration: InputDecoration(
                    labelText: "Status",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15)),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<ChangeProfileController>(
                      builder: (value) => value.pickedImage != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 110,
                                  width: 125,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(value.pickedImage!.path),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -5,
                                        child: IconButton(
                                          onPressed: () => value.resetImage(),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[900],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => value
                                      .uploadImage(authC.user.value.uid!)
                                      .then((hasilKembalian) {
                                    if (hasilKembalian != null) {
                                      authC.updatePhotoUrl(hasilKembalian);
                                    }
                                  }),
                                  child: const Text(
                                    "upload",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Text("no image"),
                    ),
                    TextButton(
                        onPressed: () => controller.selectImage(),
                        child: const Text(
                          "chosen..",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    authC.changeProfile(
                        controller.nameC.text, controller.statusC.text);
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
