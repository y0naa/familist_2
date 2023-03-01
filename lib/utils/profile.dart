import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class Profile {
  CollectionReference families =
      FirebaseFirestore.instance.collection("families");

  Future doesFamilyExist(String docID) async {
    final doc = await families.doc(docID).get();
    final bool exists = doc.exists;
    print("exists: $exists");
    return exists;
  }

  Future getFamiliesId() async {
    List<String> familyIDs = [];
    await FirebaseFirestore.instance.collection("families").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              familyIDs.add(document.reference.id);
            },
          ),
        );
    return familyIDs;
  }

  Future getFamilyName(String fuid) async {
    String familyName = "";
    await FirebaseFirestore.instance
        .collection("families")
        .doc(fuid)
        .get()
        .then(
      (snapshot) {
        familyName = snapshot.get("family-name");
        print("tesfamily name: $familyName");
      },
    );
    return familyName;
  }

  Future getUserID() async {
    String id = "";
    await FirebaseFirestore.instance
        .collection("users")
        .where(
          "email",
          isEqualTo: Auth().currentUser!.email!.trim(),
        )
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        id = snapshot.docs.first.id;
      }
    });

    return id;
  }

  Future<Map<String, String>> getUserDetails() async {
    Map<String, String> data = {};
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(
          "email",
          isEqualTo: Auth().currentUser!.email!.trim(),
        )
        .get();
    if (snapshot.docs.isNotEmpty) {
      final document = snapshot.docs.first;
      data["doc_id"] = document.reference.id;
      data["fuid"] = document.get("fuid");
      data["full name"] = document.get("full name");
      data["bio"] = document.get("bio");
      data["telephone"] = document.get("telephone");
      data["imageUrl"] = document.get("imageUrl");
    }
    return data;
  }

  Future getFamilyID() async {
    String fuid = "";
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(
          "email",
          isEqualTo: Auth().currentUser!.email!.trim(),
        )
        .get();
    if (snapshot.docs.isNotEmpty) {
      final document = snapshot.docs.first;
      fuid = document.get("fuid");
    }
    return fuid;
  }

  Future updateData(String docID, Map<Object, Object?> map) async {
    await FirebaseFirestore.instance.collection("users").doc(docID).update(map);
  }

  Future updateFamilyName(String newName) async {
    Map<String, String> data = await getUserDetails();
    String userId = await getUserID();

    print("data: $data");
    if (data['fuid'] != null && data["fuid"]!.length > 4) {
      print("notnull");
      await FirebaseFirestore.instance
          .collection("families")
          .doc(data["fuid"])
          .update({
        "family-name": newName,
      });
    } else {
      print("here ");
      await FirebaseFirestore.instance.collection("families").add({
        "family-name": newName,
      }).then((docRef) async {
        await updateData(userId, {"fuid": docRef.id});
      });
    }
  }

  Future getUsersId() async {
    List<String> userIDs = [];
    await FirebaseFirestore.instance.collection("users").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              userIDs.add(document.reference.id);
            },
          ),
        );
    return userIDs;
  }
}
