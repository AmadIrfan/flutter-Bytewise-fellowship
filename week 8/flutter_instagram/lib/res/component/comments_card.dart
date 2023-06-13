import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsCard extends StatelessWidget {
  const CommentsCard({super.key, required this.snap});
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  @override
  Widget build(BuildContext context) {
    // IUser u =
    //     Provider.of<UserProvider>(context, listen: false).getUser as IUser;
    // if (kDebugMode) {
    //   print(u.userName);
    // }
    FireStoreMethost p = Provider.of<FireStoreMethost>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          snap['uprofile'].toString().isEmpty
              ? const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/images.png'),
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    snap['uprofile'].toString(),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          text: snap['userName'].toString(),
                        ),
                        TextSpan(
                          text: '  ${snap['comments']}',
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(
                            DateTime.parse(
                              snap['dateTime'].toString(),
                            ),
                          )
                          .toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              onPressed: () {
                p.likeComments(
                    snap['postId'], snap['uId'], snap['cmtId'], snap['likes']);
              },
              icon: (snap['likes'] as List<dynamic>).contains(
                snap['uId'],
              )
                  ? const Icon(
                      Icons.favorite,
                      size: 16,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      size: 16,
                      // color: Colors.red,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
