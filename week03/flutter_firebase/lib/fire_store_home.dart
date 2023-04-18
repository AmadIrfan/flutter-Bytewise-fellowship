import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseFireStoreHome extends StatelessWidget {
  const FirebaseFireStoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase FireStore'),
      ),
      body: SizedBox(
        height: 500,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Blog').snapshots(),
          builder: (context, snapShot) {
            final item = snapShot.data?.docs;
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: item!.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Blog')
                            .doc(item[index].id)
                            .collection('BlogPost')
                            .snapshots(),
                        builder: (context, sp) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final da = sp.data?.docs;
                            final itemList = [];
                            da?.map((e) {
                              itemList.add(e.id);
                            });
                            return SizedBox(
                                height: 500,
                                child: Column(
                                  children: [
                                    ...itemList.map(
                                      (e) => Text(e) as Widget,
                                    ),
                                  ],
                                )
                                // child: ListView.builder(
                                //   itemCount: da?.length,
                                //   itemBuilder: (context, ind) => Text(
                                //     (da?[ind].id).toString(),
                                //   ),
                                // ),
                                );
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
