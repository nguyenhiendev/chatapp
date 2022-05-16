import 'dart:async';

import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/utils/loading_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';
import 'package:chatapp/app/modules/chat_room/views/widget/item_chat.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  ChatRoomView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final String chatId = (Get.arguments as Map<String, dynamic>)["chat_id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leadingWidth: 100,
        backgroundColor: Colors.blue[500],
        leading: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: controller.streamFriendData(
                      (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                  builder: (context, snapFriendUser) {
                    if (snapFriendUser.connectionState ==
                        ConnectionState.active) {
                      var dataFriend =
                          snapFriendUser.data!.data() as Map<String, dynamic>;
                      if (dataFriend["photoUrl"] == "noimage") {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/logo/noimage.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            dataFriend["photoUrl"],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/logo/noimage.png",
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.streamFriendData(
              (Get.arguments as Map<String, dynamic>)["friendEmail"]),
          builder: (context, snapFriendUser) {
            if (snapFriendUser.connectionState == ConnectionState.active) {
              var dataFriend =
                  snapFriendUser.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataFriend["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    dataFriend["status"],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Get.back();
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChats(chatId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        var allData = snapshot.data!.docs;
                        Timer(
                            Duration.zero,
                            () => controller.scrollC.jumpTo(
                                controller.scrollC.position.maxScrollExtent));
                        return ListView.builder(
                          reverse: true,
                          controller: controller.scrollC,
                          itemCount: allData.length,
                          padding: const EdgeInsets.only(top: 15),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    "${allData[index]["groupTime"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ItemChat(
                                    msg: "${allData[index]["msg"]}",
                                    isSender: allData[index]["sender"] ==
                                            authC.user.value.email!
                                        ? true
                                        : false,
                                    time: "${allData[index]["time"]}",
                                  ),
                                ],
                              );
                            } else {
                              if (allData[index]["groupTime"] ==
                                  allData[index - 1]["groupTime"]) {
                                return ItemChat(
                                  msg: "${allData[index]["msg"]}",
                                  isSender: allData[index]["sender"] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  time: "${allData[index]["time"]}",
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      "${allData[index]["groupTime"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ItemChat(
                                      msg: "${allData[index]["msg"]}",
                                      isSender: allData[index]["sender"] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                      time: "${allData[index]["time"]}",
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                      return const Center(child: LoadingScreen());
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: controller.isShowEmoji.isTrue
                        ? 5
                        : context.mediaQueryPadding.bottom),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SizedBox(
                      child: TextField(
                        autocorrect: false,
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                              onPressed: () {
                                controller.focusNode.unfocus();
                                controller.isShowEmoji.toggle();
                              },
                              icon: const Icon(Icons.emoji_emotions_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(width: 10),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue[600],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => (controller.isShowEmoji.isTrue)
                  ? SizedBox(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        },
                        config: const Config(
                          backspaceColor: Colors.blue,
                          columns: 7,
                          emojiSizeMax: 32.0,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: "No Recents",
                          noRecentsStyle:
                              TextStyle(fontSize: 20, color: Colors.black26),
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
