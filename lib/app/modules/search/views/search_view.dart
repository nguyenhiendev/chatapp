import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  SearchView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.blue[600],
          title: const Text('Search'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 20, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: (value) =>
                    controller.searchFriend(value, authC.user.value.email!),
                controller: controller.searchC,
                cursorColor: Colors.blue[600],
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.white, width: 1),
                  ),
                  hintText: 'Search new friend here...',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  suffixIcon: InkWell(
                    onTap: () {},
                    child: Icon(Icons.search, color: Colors.blue[600]),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(140),
      ),
      body: Obx(
        () => controller.tempSearch.isEmpty
            ? Center(
                child: SizedBox(
                  width: Get.width * 0.7,
                  height: Get.height * 0.7,
                  child: Lottie.asset('assets/lottie/empty.json'),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black26,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          controller.tempSearch[index]["photoUrl"] == "noimage"
                              ? Image.asset(
                                  'assets/logo/noimage.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  controller.tempSearch[index]["photoUrl"],
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  title: Text(
                    "${controller.tempSearch[index]["name"]}",
                    textScaleFactor: 1,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "${controller.tempSearch[index]["email"]}",
                    textScaleFactor: 1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  trailing: GestureDetector(
                    onTap: () => authC.addNewConnection(
                        controller.tempSearch[index]["email"]),
                    child: const Chip(
                      label: Text(
                        'Message',
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
