import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/res/component/message_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message_outlined,
            ),
          ),
        ],
        title: Image.asset(
          'assets/images/insta.png',
          height: 32,
          color: Colors.white,
        ),
        backgroundColor: mobileBgColor,
      ),
      body: StreamBuilder(
          stream: _fireStore.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (
                  context,
                  index,
                ) =>
                    MessageCard(
                  snapShot:
                      snapshot.data?.docs[index].data() as Map<String, dynamic>,
                ),
              );
            }
          }),
    );
  }
}
