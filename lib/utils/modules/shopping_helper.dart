import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:flutter/material.dart';

import '../../widgets/dialog.dart';

class ShoppingHelper {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future addShoppingItem(Map<String, dynamic> input, String uid) async {
    await users.doc(uid).collection("shopping").add(input);
  }

  Future toggleCompletedItem(String uid, String itemId, bool toggle) async {
    print("toggle compelete from uid $uid");
    await users
        .doc(uid)
        .collection("shopping")
        .doc(itemId)
        .update({"completed": toggle});
    print("toggle compelted");
  }

  Future deleteItem(BuildContext context, String docID) async {
    try {
      String userID = await Profile.getUserID();
      DocumentSnapshot snapshot =
          await users.doc(userID).collection("shopping").doc(docID).get();

      if (snapshot.exists) {
        await users.doc(userID).collection("shopping").doc(docID).delete();
        if (context.mounted) {
          dialog(
            context,
            "Delete Successful",
          );
        }
      } else {
        if (context.mounted) {
          dialog(
            context,
            "You can only delete your own items",
          );
        }
      }
    } catch (e) {
      dialog(context, e.toString());
    }
  }

  Future getShoppingItems(BuildContext context) async {
    try {
      String fuid = await Profile().getFamilyID();
      String currID = await Profile.getUserID();
      QuerySnapshot usersQuerySnapshot =
          await users.where('fuid', isEqualTo: fuid).get();
      Map<String, List<Map<String, dynamic>>> shoppingMap = {};
      for (QueryDocumentSnapshot userDoc in usersQuerySnapshot.docs) {
        String userId = userDoc.id;
        String fullName = userDoc.get("full name");
        CollectionReference shoppingRef =
            users.doc(userId).collection('shopping');
        QuerySnapshot shoppingQuerySnapshot = await shoppingRef.get();
        List<Map<String, dynamic>> shoppingList = [];
        for (QueryDocumentSnapshot shoppingDoc in shoppingQuerySnapshot.docs) {
          Map<String, dynamic> shoppingData =
              shoppingDoc.data() as Map<String, dynamic>;
          shoppingData['fullName'] = fullName;
          shoppingData['userID'] = userId;
          shoppingData['itemID'] = shoppingDoc.id;
          shoppingData['currentID'] = currID;
          shoppingList.add(shoppingData);
        }
        shoppingMap[userId] = shoppingList;
      }
      return shoppingMap;
    } catch (e) {
      dialog(
        context,
        e.toString(),
      );
    }
  }
}
