import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  CollectionReference families =
      FirebaseFirestore.instance.collection("families");

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
    print("running getfamilyname ");
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

  Future getUsersId() async {
    List<String> userIDs = [];
    await FirebaseFirestore.instance.collection("users").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              userIDs.add(document.reference.id);
            },
          ),
        );
    // await Future.wait(
    //   familyIDs.map(
    //     (doc) async {
    //       print("doc in getuserID = $doc");
    //       final querySnapshot = await FirebaseFirestore.instance
    //           .collection("families")
    //           .doc(doc)
    //           .collection("users")
    //           .get();
    //       final userDocs = querySnapshot.docs;
    //       for (final document in userDocs) {
    //         userIDs.add(document.reference.id);
    //         print("user id: $userIDs");
    //       }
    //     },
    //   ),
    // );
    // print("user id: $userIDs");
    return userIDs;
  }
}
