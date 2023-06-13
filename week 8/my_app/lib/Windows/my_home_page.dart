import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/Windows/privew_image.dart';

import '../model/post_model.dart';
import 'my_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// void getData() async {
//   await FirebaseFirestore.instance
//       .collection('/Blog')
//       .get()
//       .then((event) => event.docs.forEach(
//             (element) {
//               print("Id ${event.docs.length}");
//             },
//           ));

//   print('done');
// }

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth user = FirebaseAuth.instance;
  final stream = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    // String? userId = user.currentUser?.uid;
    // getData();
    return Scaffold(
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Posts',
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: stream.collection('Blog').snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.hasError) {
            return Text(
              snapShot.data.toString(),
            );
          } else if (snapShot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Blogs Available',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          } else {
            // return Text("data");
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  final d = snapShot.data!.docs[index];
                  Posts p = Posts(
                    body: d['body'],
                    postId: d['postId'],
                    userId: d['userId'],
                    imagePost: d['imagePost'],
                    title: d['title'],
                    dateTime: DateTime.parse(d['dateTime'].toString()),
                    updatedTime: DateTime.parse(d['dateTime'].toString()),
                  );
                  List<Posts> docList = [];
                  for (int i = 0; i < snapShot.data!.docs.length; i++) {
                    docList.insert(0, p);
                  }
                  return Card(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (context) => ImagePreviewScreen(
                                text: docList[index].title.toString(),
                                imageUrl: docList[index].imagePost.toString(),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: CircleAvatar(
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
                              ),
                            ),
                            ListTile(
                              title: Text(
                                docList[index].title.toString(),
                              ),
                              subtitle: Text(
                                docList[index].body.toString(),
                              ),
                            ),
                            const Divider(),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: docList[index]
                                            .imagePost
                                            .toString()
                                            .isEmpty
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
                                              seconds: 1,
                                            ),
                                            placeholder:
                                                'Assets/Logo/image.gif',
                                            image: docList[index]
                                                .imagePost
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
                  // : Center(
                  //     child: Text(
                  //       'No Blogs Available',
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  // );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
