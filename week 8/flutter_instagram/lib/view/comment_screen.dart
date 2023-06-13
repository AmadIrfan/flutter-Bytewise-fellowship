import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:flutter_instagram/model_view/provider/user_provider.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/res/component/comments_card.dart';
import 'package:provider/provider.dart';

import '../model_view/model/iuser.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    super.key,
    required this.postId,
  });
  final String postId;
  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentsController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    IUser u = Provider.of<UserProvider>(context).getUser as IUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        title: const Text('Comments'),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('posts')
            .doc(widget.postId)
            .collection('Comments')
            .orderBy(
              'dateTime',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Commnets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return CommentsCard(
                    snap: snapshot.data?.docs[index],
                  );
                },
                itemCount: snapshot.data?.docs.length,
              );
            }
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          // color: Colors.red,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              u.imageUrl.toString().isEmpty
                  ? const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('assets/images/images.png'),
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        u.imageUrl.toString(),
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: TextField(
                    controller: _commentsController,
                    decoration: InputDecoration(
                      hintText: 'Comments as ${u.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        void comments = Provider.of<FireStoreMethost>(context,
                                listen: false)
                            .postComments(
                          widget.postId,
                          _commentsController.text,
                          u.userId.toString(),
                          u.userName.toString(),
                          u.imageUrl!.toString(),
                        );
                        comments;
                        setState(
                          () {
                            isLoading = false;
                            remover();
                          },
                        );
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void remover() {
    _commentsController.text = '';
    setState(() {});
  }
}
