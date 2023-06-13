import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/res/component/follow_button.dart';
import 'package:flutter_instagram/view/login_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uId});
  final String uId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _userData = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _plength = 0;
  int _following = 0;
  int _follower = 0;

  bool _isFolowing = false;
  bool _isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FireStoreMethost fireStoreMethost =
        Provider.of<FireStoreMethost>(context, listen: false);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              title: Text(_userData['userName'].toString()),
              centerTitle: false,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getData();
              },
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.amber,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      buildStateColumn(_plength, 'Posts'),
                                      buildStateColumn(_follower, 'Followers'),
                                      buildStateColumn(_following, 'Following'),
                                    ],
                                  ),
                                  Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uId
                                          ? FollowButton(
                                              backgroundColor: mobileBgColor,
                                              borderColor: Colors.blueGrey,
                                              function: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginView(),
                                                  ),
                                                );
                                              },
                                              text: 'Signout',
                                              textColor: primaryColor,
                                            )
                                          : _isFolowing
                                              ? FollowButton(
                                                  backgroundColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () {
                                                    String? uid = FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid;
                                                    fireStoreMethost.followUser(
                                                        uid.toString(),
                                                        _userData['userId']
                                                            .toString());
                                                    setState(() {});
                                                  },
                                                  text: 'Un Follow',
                                                  textColor: Colors.white,
                                                )
                                              : FollowButton(
                                                  backgroundColor: primaryColor,
                                                  borderColor: Colors.blue,
                                                  function: () {
                                                    String? uid = FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid;
                                                    fireStoreMethost.followUser(
                                                        uid.toString(),
                                                        _userData['userId']
                                                            .toString());
                                                    setState(() {});
                                                  },
                                                  text: 'Follow',
                                                  textColor: Colors.white,
                                                )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            _userData['userName'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            _userData['bio'].toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 500,
                    child: FutureBuilder(
                      future: _firestore
                          .collection('posts')
                          .where('uId', isEqualTo: widget.uId)
                          .get(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: ((context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              return Container(
                                color: Colors.red,
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    snap['imagePath'].toString(),
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStateColumn(int num, String lable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            lable,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userSnap =
          await _firestore.collection('users').doc(widget.uId).get();
      QuerySnapshot postSnap = await _firestore
          .collection('posts')
          .where('uId', isEqualTo: widget.uId)
          .get();
      setState(
        () {
          _isFolowing =
              ((userSnap.data() as Map<String, dynamic>)['followers'] as List)
                  .contains(
            FirebaseAuth.instance.currentUser?.uid.toString(),
          );
          _userData = userSnap.data() as Map<String, dynamic>;
          _plength = postSnap.docs.length;
          _follower =
              (userSnap.data() as Map<String, dynamic>)['followers'].length;
          _following =
              (userSnap.data() as Map<String, dynamic>)['following'].length;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
