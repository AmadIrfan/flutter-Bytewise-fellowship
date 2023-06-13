import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/res/component/animation_builder.dart';
import 'package:flutter_instagram/view/comment_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model_view/provider/user_provider.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.snapShot,
  });
  final Map<String, dynamic> snapShot;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isLikeAnimating = false;
  int _tComments = 0;
  @override
  void initState() {
    super.initState();
    getComents();
  }

  void getComents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapShot['pId'])
          .collection('Comments')
          .get();
      int t = querySnapshot.docs.length;
      setState(() {
        _tComments = t;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pUser = Provider.of<UserProvider>(context, listen: false);
    pUser.refreshUser();
    final u = pUser.getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ).copyWith(
        right: 0,
      ),
      decoration: const BoxDecoration(
        color: mobileBgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              u?.imageUrl == null || u!.imageUrl!.isEmpty
                  ? const CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage('assets/images/images.png'),
                    )
                  : CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.snapShot['userProfile'].toString(),
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snapShot['userName'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        children: ['Delete']
                            .map(
                              (e) => InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Text(e),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
              Provider.of<FireStoreMethost>(context, listen: false).likePost(
                  widget.snapShot['pId'],
                  u!.userId.toString(),
                  widget.snapShot['likes']);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snapShot['imagePath'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(microseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    duration: const Duration(milliseconds: 400),
                    isanimating: isLikeAnimating,
                    onEnd: () {
                      setState(
                        () {
                          isLikeAnimating = false;
                        },
                      );
                    },
                    smalLike: false,
                    child: widget.snapShot['likes'].contains(
                      u?.userId,
                    )
                        ? const Icon(
                            Icons.favorite,
                            size: 100,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 100,
                          ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                smalLike: true,
                onEnd: () {},
                duration: const Duration(milliseconds: 200),
                isanimating: widget.snapShot['likes'].contains(
                  u?.userId,
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<FireStoreMethost>(context, listen: false)
                        .likePost(widget.snapShot['pId'], u!.userId.toString(),
                            widget.snapShot['likes']);
                  },
                  icon: widget.snapShot['likes'].contains(
                    u?.userId,
                  )
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          // color: Colors.red,
                        ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snapShot['pId'].toString(),
                      ),
                    ),
                  ).then((value) {
                    getComents();
                  });
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '${widget.snapShot['likes'].length}  Likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: '${widget.snapShot['userName']}  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${widget.snapShot['description']}  ',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snapShot['pId'],
                        ),
                      ),
                    ).then((value) {
                      getComents();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $_tComments comments',
                      style: const TextStyle(
                        color: secondColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      DateTime.parse(
                        widget.snapShot['timeStemp'].toString(),
                      ),
                    ),
                    style: const TextStyle(
                      color: secondColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
