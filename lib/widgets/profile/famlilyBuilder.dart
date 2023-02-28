import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familist_2/utils/auth.dart';
import 'package:familist_2/utils/profile.dart';
import 'package:familist_2/widgets/loadingText.dart';
import 'package:familist_2/widgets/profile/memberCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FamilyBuilder extends StatefulWidget {
  const FamilyBuilder({
    super.key,
  });

  @override
  State<FamilyBuilder> createState() => _FamilyBuilderState();
}

class _FamilyBuilderState extends State<FamilyBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    Future familyBuilder() async {
      String fuid = await Profile().getFamilyID();
      //print(users.where("fuid", isEqualTo: fuid).get());
      return users.where("fuid", isEqualTo: fuid).get();
    }

    return FutureBuilder(
      future: familyBuilder(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.docs.isEmpty) {
            return const Text("No members found");
          }

          return SizedBox(
            height: size.height * 0.3,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final doc = snapshot.data!.docs[index];
                final name = doc.get("full name");

                print(
                    "snapshot name: ${doc.get("email")}, user email: ${Auth().currentUser!.email}");
                if (Auth().currentUser!.email == doc.get("email")) {
                  print("is samee");
                  return Member(
                    name: name,
                    isUser: true,
                    docID: doc.id,
                    refresh: () {
                      setState(() {});
                    },
                  );
                } else {
                  print("isnt samee");
                  return Member(
                    name: name,
                    isUser: false,
                    docID: doc.id,
                    refresh: () {
                      setState(() {});
                    },
                  );
                }
              },
            ),
          );
        }

        return Center(
          child: Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
