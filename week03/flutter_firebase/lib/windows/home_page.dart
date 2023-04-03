import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/widget/theme_changer.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_firebase/windows/add_notes.dart';
import 'package:flutter_firebase/windows/notes_details.dart';
import 'package:flutter_firebase/Auth/login_page.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:provider/provider.dart';

enum POPUP {
  edit,
  delete,
}

enum Action {
  logOut,
  theme,
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter FireBase'),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: const Text('Log Out'),
          //         content: const Text('Are you sure you want to log out ??'),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(context, true);
          //             },
          //             child: const Text('No'),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               Utils().resultMessage('Log Out Successfully');
          //               FirebaseAuth.instance.signOut();
          //               Navigator.of(context).pushReplacement(
          //                 MaterialPageRoute(
          //                   builder: (context) => const LoginPage(),
          //                 ),
          //               );
          //             },
          //             child: const Text('Yes'),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          //   child: const Text('Sign out'),
          // ),
          PopupMenuButton(
            onSelected: (value) {
              if (Action.logOut == value) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out ??'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Utils().resultMessage('Log Out Successfully');
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              } else if (Action.theme == value) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Change Theme'),
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          RadioListTile<ThemeMode>(
                            onChanged: themeChanger.setThemeMod,
                            groupValue: themeChanger.themMode,
                            value: ThemeMode.system,
                            title: const Text('System Mode'),
                          ),
                          RadioListTile<ThemeMode>(
                            onChanged: themeChanger.setThemeMod,
                            groupValue: themeChanger.themMode,
                            value: ThemeMode.dark,
                            title: const Text('Dark Mode'),
                          ),
                          RadioListTile<ThemeMode>(
                            onChanged: themeChanger.setThemeMod,
                            groupValue: themeChanger.themMode,
                            value: ThemeMode.light,
                            title: const Text('Light Mode'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Action.logOut,
                child: Text('Log Out'),
              ),
              const PopupMenuItem(
                value: Action.theme,
                child: Text('Change Theme'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref('Post/$uid').ref.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  Object? temp = snapshot.data?.snapshot.value;
                  Map<dynamic, dynamic> items = {};
                  if (temp != null) {
                    items = snapshot.data?.snapshot.value as dynamic;
                  }
                  List<dynamic> list = [];
                  list.clear();
                  list = items.values.toList();

                  return Card(
                    elevation: 2,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NotesDetails.routName,
                              arguments: {
                                'title': list[index]['title'],
                                'id': list[index]['id'],
                                'text': list[index]['text'],
                                'dateTime': list[index]['dateTime'],
                              },
                            );
                          },
                          title: Text(
                            list[index]['title'],
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          subtitle: Text(
                            list[index]['dateTime'],
                            softWrap: true,
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (POPUP.edit == value) {
                                Navigator.of(context).pushNamed(
                                  AddNotes.routeName,
                                  arguments: {
                                    'title': list[index]['title'],
                                    'id': list[index]['id'],
                                    'text': list[index]['text'],
                                  },
                                );
                              } else {
                                final ref =
                                    FirebaseDatabase.instance.ref('Post/$uid');
                                ref
                                    .child(
                                      list[index]['id'],
                                    )
                                    .remove();
                                Utils().resultMessage('Deleted');
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: POPUP.edit,
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: POPUP.delete,
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingBtn,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _floatingBtn() {
    Navigator.of(context).pushNamed(
      AddNotes.routeName,
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    Uri url = Uri.parse(
        'https://fir-complete-a3531-default-rtdb.firebaseio.com/Post.json');
    Response rep = await http.get(
      url,
    );
    final exData = json.decode(rep.body) as Map<String, dynamic>;
    exData.forEach((key, value) {});
    return exData;
  }
}

//  FirebaseAnimatedList(
//               query: ref,
//               itemBuilder: (context, snapshot, anima, index) => Card(
//                 child: ListTile(
//                   title: Text(
//                     snapshot.child('title').value.toString(),
//                   ),
//                   subtitle: Text(
//                     snapshot.child('text').value.toString(),
//                   ),
//                   trailing: PopupMenuButton(
//                     // icon: Icon(Icons.copy),
//                     onSelected: (v) {
//                       if (kDebugMode) {
//                         print(v);
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(
//                         child: Text('Edit'),
//                       ),
//                       const PopupMenuItem(
//                         child: Text('Delete'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
