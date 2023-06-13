import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/view/profile_screen.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isFieldSubmitted = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBgColor,
          title: TextField(
            autofocus: false,
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search User here',
              suffix: IconButton(
                onPressed: () {
                  _controller.text = '';
                },
                icon: const Icon(Icons.remove),
              ),
            ),
            onSubmitted: (text) {
              setState(
                () {
                  _isFieldSubmitted = true;
                },
              );
            },
          ),
        ),
        body: _isFieldSubmitted
            ? FutureBuilder(
                future: _firestore
                    .collection('users')
                    .where(
                      'userName',
                      isGreaterThanOrEqualTo: _controller.text,
                    )
                    .get(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapShot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                print(snapShot.data?.docs[index]['userId']);
                                return ProfileScreen(
                                  uId: snapShot.data?.docs[index]['userId'],
                                );
                              }),
                            );
                          },
                          leading: const CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                AssetImage('assets/images/images.png'),
                          ),
                          title: Text(
                            (snapShot.data?.docs[index]['userName']).toString(),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : Container()
        // : FutureBuilder(
        //     future: _firestore.collection('posts').get(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const CircularProgressIndicator();
        //       } else {
        //         return Expanded(
        //           child: StaggeredGrid.count(
        //             crossAxisCount: 4,
        //             mainAxisSpacing: 4,
        //             crossAxisSpacing: 4,
        //             children: [
        //               ListView.builder(
        //                 itemCount: 10,
        //                 itemBuilder: (context, index) {
        //                   return StaggeredGridTile.count(
        //                     key: ValueKey(index),
        //                     crossAxisCellCount: 2,
        //                     mainAxisCellCount: 2,
        //                     child: Text(index.toString()),
        //                   );
        //                 },
        //               )
        //             ],
        //           ),
        //         );
        //       }
        //     },
        //   ),
        );
  }
}
