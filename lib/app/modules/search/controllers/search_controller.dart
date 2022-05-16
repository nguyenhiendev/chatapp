import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;

  var queryBegin = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    print("SEARCH : $data");

    if (data.isEmpty) {
      queryBegin.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);

      print(capitalized);

      if (queryBegin.isEmpty && data.length == 1) {
        // The function to be executed on the first letter typed
        CollectionReference users = firestore.collection("users");
        final keyNameResult = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: email)
            .get();

        print("TOTAL DATA : ${keyNameResult.docs.length}");
        if (keyNameResult.docs.isNotEmpty) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryBegin
                .add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }

          print("QUERY RESULT : ");

          print(queryBegin);
        } else {
          print("NO DATA");
        }
      }

      if (queryBegin.isNotEmpty) {
        tempSearch.value = [];
        for (var element in queryBegin) {
          if (element["name"].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        }
      }
    }

    queryBegin.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
