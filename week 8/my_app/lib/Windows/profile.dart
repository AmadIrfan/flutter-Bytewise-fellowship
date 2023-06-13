// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/detail_model.dart';
import 'add_data.dart';
import 'my_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUData() async {
    final data = await DetailsData().getUserData(_auth.currentUser!.uid);
    return data;
  }

  @override
  void initState() {
    super.initState();
    getUData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final g = await getUData();
              final list = g?['skills'];
              List<String?>? l = [];
              if (list != null) {
                for (String? i in list) {
                  l.add(i);
                }
              }
              Details dd = Details(
                _auth.currentUser!.uid,
                g?['name'].toString(),
                g?['description'].toString(),
                g?['imageUrl'].toString(),
                _auth.currentUser!.email,
                l,
              );
              Navigator.of(context)
                  .pushNamed(MyDetails.routeName, arguments: dd)
                  .then((value) {
                setState(() {});
              });
            },
            icon: const Icon(
              Icons.edit,
            ),
            tooltip: 'Edit Profile',
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      body: FutureBuilder(
          future: getUData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final list = snapshot.data?['skills'];
              // print(list);
              List<String>? _items = [];
              if (list != null) {
                list.forEach((element) {
                  _items.add(
                    element.toString(),
                  );
                });
              }
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: const Image(
                          image: AssetImage(
                            'Assets/Logo/images1.jpeg',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      (snapshot.data?['name']).toString().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // const Text(
                    //   'Software Engineer',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              const Text(
                                'About Me',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${snapshot.data?['description']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Skills',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 15,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _items.length,
                                      itemBuilder: (context, index) => Chip(
                                        label: Text(
                                          _items[index],
                                        ),
                                        backgroundColor: Colors.blue[800],
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // Chip(
                                  //   label: const Text('Dart'),
                                  //   backgroundColor: Colors.blue[800],
                                  //   labelStyle: const TextStyle(color: Colors.white),
                                  // ),
                                  // Chip(
                                  //   label: const Text('Firebase'),
                                  //   backgroundColor: Colors.blue[800],
                                  //   labelStyle: const TextStyle(color: Colors.white),
                                  // ),
                                  // Chip(
                                  //   label: const Text('UI/UX Design'),
                                  //   backgroundColor: Colors.blue[800],
                                  //   labelStyle: const TextStyle(color: Colors.white),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
