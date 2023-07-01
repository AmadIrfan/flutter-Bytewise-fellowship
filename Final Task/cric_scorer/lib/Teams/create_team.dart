import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/Teams/teams.dart';
import 'package:cric_scorer/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cric_scorer/file_picker.dart';
class create_team extends StatefulWidget {
  const create_team({Key? key}) : super(key: key);

  @override
  _create_teamState createState() => _create_teamState();
}

Widget textfeilddesign(bordername, _controller, _hinttext, {max_length = 250, min_length = 1}) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: TextFormField(
        controller: _controller,
        cursorColor: Colors.green,
        validator: (val) {
          if (val!.isEmpty) {
            return 'required';
          }
          if(val.length < min_length){
            return 'Minimum length should be $min_length characters';
          }
          if (val.length > max_length) {
            return 'Max Length exceeding';
          }
        },
        // maxLength: max_length,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: _hinttext,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(4)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          labelText: bordername,
          labelStyle: TextStyle(
              color: Colors.grey[900],
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        )),
  );
}

class _create_teamState extends State<create_team> {
  var args = Get.arguments;
  bool inprogress = false;
  String filepath = '';
  String currentuserid = '';
  String downloadURL = '';
  bool IsSelected = false;
  CollectionReference teams = FirebaseFirestore.instance.collection('teams');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _teamname = TextEditingController();
  TextEditingController _teamlocation = TextEditingController();
  TextEditingController _teamshortname = TextEditingController();

  @override
  void initState() {
    super.initState();

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentuserid = currentUser.uid;
        _teamname.text = args[0]['team_name'];
        _teamlocation.text = args[0]['team_location'];
        _teamshortname.text = args[0]['teamshortname'];
        downloadURL = args[0]['img_url'];
      });
    }
  }

  Future<void> uploadFile(String filePath, team_name) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('images/team_logos/$currentuserid/$team_name.png')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Get.snackbar('Error occured.', '');
    }
  }


  Future<void> downloadURLfunc(cuserid, team_name) async {
    String imgurl = await firebase_storage.FirebaseStorage.instance
        .ref('images/team_logos/$cuserid/$team_name.png')
        .getDownloadURL();
    setState(() {
      downloadURL = imgurl;
    });
  }

  Future<void> savedata(__teamname, __teamlocation, __teamshortname) async {
    return args[0]['isedit'] ?
    teams.doc(currentuserid).collection('myteams').doc(args[0]['team_doc_id']).set({
      'team_name': __teamname,
      'team_location': __teamlocation,
      'teamshortname': __teamshortname,
      'imgurl': downloadURL.toString(),
    }, SetOptions(merge: true)).then((value) {
      setState(() {
        inprogress = false;
      });
      Get.back();
      customtoast('Team info updated');
      // Get.snackbar('Team Added', '');
    }).catchError((error) {
      setState(() {
        inprogress = false;
      });
      customtoast('Failed to update team: $error');
      // Get.snackbar('', 'Failed to add team: $error');
    })
    :
    teams.doc(currentuserid).collection('myteams').add({
      'team_name': __teamname,
      'team_location': __teamlocation,
      'teamshortname': __teamshortname,
      'imgurl': downloadURL.toString(),
      'stats':{
        'played' : 0,
        'won' : 0,
        'lost' : 0,
        'draw' : 0,
        'win_percentage' : 0,
      }
    }).then((value) {
      setState(() {
        inprogress = false;
      });
      Get.back();

      customtoast('Team added');
      // Get.snackbar('Team Added', '');
    }).catchError((error) {
      setState(() {
        inprogress = false;
      });
      customtoast('Failed to add team: $error');
      // Get.snackbar('', 'Failed to add team: $error');
    });
  }

  Future<void> addteam(teamname, teamlocation, teamshortname) async {
    // Call the user's CollectionReference to add a new user
    if (filepath.isNotEmpty) {
      uploadFile(filepath, teamname).then((value) {
        downloadURLfunc(currentuserid, teamname).then((value) {
          savedata(teamname, teamlocation, teamshortname);
        });
      });
    } else {
      savedata(teamname, teamlocation, teamshortname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          args[0]['appbartext'].toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: inprogress
                ? CircularProgressIndicator(
                    color: Colors.teal,
                  )
                : IconButton(
                    onPressed: inprogress
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                inprogress = true;
                              });
                              addteam(_teamname.text, _teamlocation.text,
                                  _teamshortname.text);
                            }
                          },
                    icon: Icon(
                      Icons.check,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
              onTap: () {
                filepicker().then((selectedpath) {
                  if (selectedpath.toString().isNotEmpty) {
                    setState(() {
                      filepath = selectedpath;
                      IsSelected = true;
                      // uploadFile(selectedpath.toString());
                    });
                  }
                });
              },
              child: IsSelected
                  ? CircleAvatar(
                      radius: 50.0,
                      foregroundImage: FileImage(File(filepath)),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 50.0,
                      foregroundImage: CachedNetworkImageProvider(
                          args[0]['img_url']
                          ),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black26,
                    ),
            ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Name", _teamname, 'Star Cricket Club', min_length: 3)),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Location", _teamlocation, 'Bhakkar')),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                  ),
                  child: textfeilddesign(
                      "Team Short Name", _teamshortname, 'SCC', max_length: 3)),
            ],
          ),
        ),
        Spacer(),
      ]),
    );
  }
}
