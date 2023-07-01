import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cric_scorer/file_picker.dart';
import 'package:cric_scorer/main.dart';
import 'package:cric_scorer/user%20profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key}) : super(key: key);

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  var profileargs = Get.arguments;
  bool isworking = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _displayname = TextEditingController();
  TextEditingController _countryname = TextEditingController();
  TextEditingController _cityname = TextEditingController();
  TextEditingController _email = TextEditingController();
  String path = '';
  bool IsSelected = false;
  String currentuserid = '';

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        _displayname.text = profileargs[0]['_displayname'].toString();
        _countryname.text = profileargs[0]['_countryname'].toString();
        _cityname.text = profileargs[0]['_cityname'].toString();
      });
    }
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('images/profile_pictures/$currentuserid.png')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Get.snackbar('Error occured.', '');
    }
  }

  Future<void> addUser(displayname, country, city) async {
    // Call the user's CollectionReference to add a new user
    // return profileargs[0]['isedit']
    //     ? 
    users.doc(currentuserid).set({
            'full_name': displayname,
            'country': country,
            'city': city
          }, SetOptions(merge: true)).then((value) {
            if(path.isNotEmpty){
              uploadFile(path).then((value) {
              setState(() {
                isworking = false;
              });
              
              // Get.reset(clearRouteBindings: true);
              profileargs[0]['isedit'] ?
              Get.back() :
              Get.to(HomePage(), transition: Transition.rightToLeft);
              Get.snackbar('Data Submitted', '');
            });
            }else{
            setState(() {
                isworking = false;
              });
              profileargs[0]['isedit'] ?
              Get.back() :
              Get.to(HomePage(), transition: Transition.rightToLeft);   
              Get.snackbar('Data Submitted', '');
            }
          }).catchError((error) {
            setState(() {
              isworking = false;
            });
            // Get.snackbar('', 'Failed to add user: $error');
          });
    //     : 
    // users.doc(currentuserid).set({
    //         'full_name': displayname,
    //         'country': country,
    //         'city': city
    //       }).then((value) {
    //         uploadFile(path).then((value) {
    //           setState(() {
    //             isworking = false;
    //           });
              // Get.to(HomePage(), transition: Transition.rightToLeft);
              // // Get.reset(clearRouteBindings: true);
              // profileargs[0]['isedit'] ?
    //           Get.snackbar('Data Submitted', '');
    //         });
    //       }).catchError((error) {
    //         setState(() {
    //           isworking = false;
    //         });
    //         // Get.snackbar('', 'Failed to add user: $error');
    //       });
  }

  Widget customtextformfield(lbltext, _controller, isreadonly) {
    // _controller.text = profileargs[0][_controllername].toString().trim();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_val) {
            if (_val!.isEmpty) {
              return 'required';
            }
          },
          readOnly: isreadonly,
          controller: _controller,
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: lbltext,
            // alignLabelWithHint: false,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            filled: true,
            enabled: true,
            fillColor: Color(0xFFEEECEC),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

    Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the App'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: profileargs[0]['isedit'],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            profileargs[0]['appbartitle'].toString(),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              if(profileargs[0]['isedit']){
              Navigator.pop(context);
              }else{
                _onWillPop();
              }
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          actions: [
            isworking
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      // valueColor: AlwaysStoppedAnimation(Colors.red),
                      strokeWidth: 4.0,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isworking = true;
                          // if(path.isEmpty){
                          //   path = profileargs[0]['_profilepic'].toString();
                          // }
                        });
                        addUser(
                            _displayname.text, _countryname.text, _cityname.text);
                      }
                    },
                    icon: Icon(Icons.check, color: Colors.black),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    filepicker().then((selectedpath) {
                      if (selectedpath.toString().isNotEmpty) {
                        setState(() {
                          path = selectedpath;
                          IsSelected = true;
                          // uploadFile(selectedpath.toString());
                        });
                      }
                    });
                  },
                  child: IsSelected
                      ? CircleAvatar(
                          radius: 50.0,
                          foregroundImage: FileImage(File(path)),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          foregroundImage: CachedNetworkImageProvider(
                              profileargs[0]['_profilepic'].toString()),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black26,
                        ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customtextformfield('Display Name', _displayname, false),
                    // customtextformfield('Email', _email, true),
                    customtextformfield('Country', _countryname, false),
                    customtextformfield('City', _cityname, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
