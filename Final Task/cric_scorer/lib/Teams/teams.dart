// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/Teams/create_team.dart';
import 'package:cric_scorer/Teams/team_page.dart';
import 'package:cric_scorer/main.dart';
import 'package:cric_scorer/my%20matches/create_match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
import 'package:get/get.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Teams extends StatefulWidget {
  const Teams({Key? key}) : super(key: key);

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  String currentuserid = '';
  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        // downloadURLfunc(currentuserid, 'Pakstan');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'My Teams',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Get.to(
            () => create_team(),
            transition: Transition.downToUp,
            arguments: [
              {
               'isedit' : false,
               'appbartext' : 'Create Team',
                    'currentuserid' : currentuserid.toString(),
                    'team_name' : '',
                    'img_url' : '',
                    'team_doc_id' : '',
                    'teamshortname' : '',
                    'team_location' : '',
              }
            ],
          );
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            
          });
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('teams')
              .doc(currentuserid)
              .collection('myteams')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var data = snapshot.data?.docs;
            if (snapshot.hasError) {
              return Center(
                child: Text('Something Went Wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              );
            }
            if (data!.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: 50.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'No Team',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2.0,
                    height: 5.0,
                    indent: 70.0,
                  );
                },
                itemCount: data.length, // removed null !
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ListTile(
                    onTap: () {
                      Get.to(() => TeamPage(), arguments: [
                        ds['team_name'].toString(),
                        ds['imgurl'].toString(),
                        currentuserid.toString(),
                        ds.id.toString(),
                        ds['teamshortname'].toString(),
                        ds['team_location'].toString(),
                         {
                          'won' : ds['stats']['won'],
                          'lost' : ds['stats']['lost'],
                          'played' : ds['stats']['played'],
                          'draw' : ds['stats']['draw'],
                          'win_percentage' : ds['stats']['win_percentage'],
                        }
                      ]);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      foregroundImage:
                          CachedNetworkImageProvider(ds['imgurl'].toString()),
                      child: Text(
                        ds['team_name']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      ds['team_name'],
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                       ds['teamshortname'],
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    subtitle: Text(
                      ds['team_location'],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
