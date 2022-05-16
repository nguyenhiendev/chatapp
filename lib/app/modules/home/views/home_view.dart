import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/utils/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  final ThemeData light = ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        secondary: Colors.black,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue[600],
      ));

  final ThemeData dark = ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF686D76),
        secondary: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue[600],
      ));

  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[500],
        title: const Text(
          "Chats",
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Material(
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue[500],
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatsStream(authC.user.value.email!),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.active) {
                    var listDocsChats = snapshot1.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDocsChats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .friendStream(listDocsChats[index]["connection"]),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              var data = snapshot2.data!.data();
                              return data!["status"] == ""
                                  ? ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                      onTap: () => controller.goToChatRoom(
                                        // ignore: unnecessary_string_interpolations
                                        "${listDocsChats[index].id}",
                                        authC.user.value.email!,
                                        listDocsChats[index]["connection"],
                                      ),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black26,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data["photoUrl"] == "noimage"
                                              ? Image.asset(
                                                  "assets/logo/noimage.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${data["photoUrl"]}",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        "${data["name"]}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: listDocsChats[index]
                                                  ["total_unread"] ==
                                              0
                                          ? const SizedBox()
                                          : Chip(
                                              backgroundColor: Colors.blue[600],
                                              label: Text(
                                                "${listDocsChats[index]["total_unread"]}",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    )
                                  : ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                      onTap: () => controller.goToChatRoom(
                                        // ignore: unnecessary_string_interpolations
                                        "${listDocsChats[index].id}",
                                        authC.user.value.email!,
                                        listDocsChats[index]["connection"],
                                      ),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black26,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data["photoUrl"] == "noimage"
                                              ? Image.asset(
                                                  "assets/logo/noimage.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${data["photoUrl"]}",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        "${data["name"]}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${data["status"]}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: listDocsChats[index]
                                                  ["total_unread"] ==
                                              0
                                          ? const SizedBox()
                                          : Chip(
                                              backgroundColor: Colors.blue[600],
                                              label: Text(
                                                "${listDocsChats[index]["total_unread"]}",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                    );
                            }
                            return const Center(
                              child: LoadingScreen(),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: LoadingScreen(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: const Icon(Icons.search),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
