import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Windows/privew_image.dart';

import '../Utils/show_message.dart';
import 'my_drawer.dart';

class MyPost extends StatelessWidget {
  MyPost({super.key});

  final FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? userId = user.currentUser?.uid;
    return Scaffold(
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Post',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/$userId/UserPostedIdes')
              .snapshots(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapShot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Posts',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapShot.data?.docs.length,
                itemBuilder: (context, index) {
                  final da = snapShot.data?.docs;
                  // da?[index].id
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Blog')
                        .doc(
                          da?[index].id,
                        )
                        .snapshots(),
                    builder: (context, snap) {
                      final d = snap.data?.data();
                      return InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (context) => ImagePreviewScreen(
                                text: (d?['title']).toString(),
                                imageUrl: (d?['imagePost']).toString(),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  style: ListTileStyle.list,
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Image(
                                        image: AssetImage(
                                          'Assets/Logo/images1.jpeg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    onSelected: (value) {
                                      if (PopUpValue.delete == value) {
                                        try {
                                          //      print("${d?['postId']}");
                                          FirebaseFirestore.instance
                                              .collection('Blog')
                                              .doc("${d?['postId']}")
                                              .delete();
                                          FirebaseFirestore.instance
                                              .collection(
                                                  'users/$userId/UserPostedIdes')
                                              .doc("${d?['postId']}")
                                              .delete();
                                          Utils(message: 'Post Deleted')
                                              .showMessage();
                                        } catch (e) {
                                          Utils(
                                            message: e.toString(),
                                          ).showMessage();
                                        }
                                      } else {
                                        Utils(
                                                message:
                                                    'App is in development Edit feature will be added soon')
                                            .showMessage();

                                        //             print("Edit");
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: PopUpValue.delete,
                                        child: Text("Delete"),
                                      ),
                                      const PopupMenuItem(
                                        value: PopUpValue.edit,
                                        child: Text("Edit"),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "${d?['title']}",
                                  ),
                                  subtitle: Text(
                                    "${d?['body']}",
                                  ),
                                ),
                                const Divider(),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: "${d?['imagePost']}".isEmpty ||
                                                "${d?['imagePost']}" == "null"
                                            ? const Image(
                                                image: AssetImage(
                                                  'Assets/Logo/logo.png',
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : FadeInImage.assetNetwork(
                                                fadeInDuration: const Duration(
                                                  seconds: 1,
                                                ),
                                                fadeOutDuration: const Duration(
                                                  seconds: 2,
                                                ),
                                                placeholder:
                                                    'Assets/Logo/image.gif',
                                                image: "${d?['imagePost']}"
                                                    .toString(),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

enum PopUpValue {
  delete,
  edit,
}
