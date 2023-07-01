// import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/main.dart';
import 'package:cric_scorer/user profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String currentuserid = '';
  String currentusername = '';
  String currentuseremail = '';
  String currentusercountry = '';
  String currentusercity = '';
  String currentusercreatedon = '';
  String downloadURL = '';

  Future<void> downloadURLfunc(cuserid) async {
  String imgurl = await firebase_storage.FirebaseStorage.instance
      .ref('images/profile_pictures/$cuserid.png')
      .getDownloadURL();
      setState(() {
        downloadURL = imgurl;
      });
}

  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        currentuseremail = currentUser.email!;
        currentusercreatedon = currentUser.metadata.creationTime!.toString();
      downloadURLfunc(currentuserid);
      });
     
    }
  }


  Widget customtile(_title, _trailing) {
    return ListTile(
      title: Text(
        _title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      trailing: Text(
        _trailing,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget CustomDivider() {
    return Divider(
      indent: 10.0,
      endIndent: 10.0,
      color: Colors.grey[800],
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentuserid)
        .get()
        .then((DocumentSnapshot docsnap) {
      if (docsnap.exists) {
        setState(() {
          currentusername = docsnap['full_name'];
          currentusercountry = docsnap['country'];
          currentusercity = docsnap['city'];
        });
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: IconButton(
          //     tooltip: 'Delete Profile',
          //     onPressed: () {
               
          //     },
          //     icon: Icon(
          //       FontAwesomeIcons.userMinus,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              tooltip: 'Edit Profile',
              onPressed: () {
                Get.to(
                  Editprofile(),
                  transition: Transition.leftToRight,
                  arguments: [
                    {
                      'isedit' : true,
                      'appbartitle': 'Edit profile',
                      '_displayname': currentusername,
                      '_countryname': currentusercountry,
                      '_cityname': currentusercity,
                      '_profilepic':
                          downloadURL.toString(),
                    },
                  ],
                );
              },
              icon: Icon(
                FontAwesomeIcons.userEdit,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Center(
            child: CircleAvatar(
              radius: 50.0,
              foregroundImage: CachedNetworkImageProvider(
                    downloadURL.toString()),
              child: Icon(
                  Icons.person,
                  size: 80.0,
                  color: Colors.white,
              ),
              backgroundColor: Colors.black26,
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentusername,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: FirebaseAuth.instance.currentUser!.emailVerified ?
                  Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: Colors.teal,
                    size: 20.0,
                  )
                  :
                  Text(''),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              currentuseremail,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          CustomDivider(),
          customtile('Country', currentusercountry),
          CustomDivider(),
          customtile('City', currentusercity),
          CustomDivider(),
          customtile('Created on', currentusercreatedon),
          CustomDivider(),
        ],
      ),
    );
  }
}

// ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.transparent,
//                   child: Icon(
//                     FontAwesomeIcons.solidUserCircle,
//                     color: Colors.grey,
//                     size: 40.0,
//                   ),
//                 ),
//                 title: Text(
//                   'Shami',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 subtitle: Text(
//                   'abc11@gmail.com',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),