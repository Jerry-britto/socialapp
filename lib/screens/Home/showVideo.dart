import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/auth/auth.dart';
import 'package:videoapp/components/Card.dart';

class SearchVideo extends StatefulWidget {
  const SearchVideo({super.key});

  @override
  State<SearchVideo> createState() => _SearchVideoState();
}

class _SearchVideoState extends State<SearchVideo> {
  List<Map<String, dynamic>> listOfRequest = [];
  Future<void> getRequests() async {
    print('\n');
    await FirebaseFirestore.instance
        .collection("posts")
        .where("user", isEqualTo: Auth().getCurrentUser())
        .get()
        .then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> documents = snapshot.docs;
      for (QueryDocumentSnapshot doc in documents) {
        print(doc.data());
        final data = {'docid': doc.id, 'data': doc.data()};
        setState(() {
          listOfRequest.add(data);
        });
      }
      print(
          "\n\n list of requests is as follows with length ${listOfRequest.length}");
      print('\n $listOfRequest\n\n');
    }).onError((error, stackTrace) {
      print("Error displayed while getting requests of scribe");
    });
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            listOfRequest.clear();
          });
          await getRequests();
        },
        child: listOfRequest == [] || listOfRequest.isEmpty
            ? const Center(child: Text("No Requests"))
            : ListView(
                children: [
                  Column(
                    children: List.generate(listOfRequest.length, (index) {
                      return CardInfo(
                        category: listOfRequest[index]["data"]["category"],
                        title: listOfRequest[index]["data"]["videoTitle"],
                        location: listOfRequest[index]["data"]["location"],
                        url: listOfRequest[index]["data"]["url"],
                        description: listOfRequest[index]["data"]["description"],
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
