import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:familist_2/widgets/profile/memberCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FamilyBuilder extends StatelessWidget {
  final String usersId;
  const FamilyBuilder({super.key, required this.usersId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    return FutureBuilder(
      future: users.doc(usersId).get(),
      builder: ((context, snapshot) {
        print("snapshot: $snapshot");
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.data() == null) {
            return const Text("No members found");
          }
          print("tes ${snapshot.data!.data()}");
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Member(name: data["full name"]);
        }
        return const Text("Laoading");
      }),
    );
  }
}
