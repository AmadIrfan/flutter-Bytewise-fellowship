// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

import '../Utils/show_message.dart';
import '../model/detail_model.dart';

class MyDetails extends StatefulWidget {
  const MyDetails({super.key});

  static const routeName = '/myDetails';
  @override
  State<MyDetails> createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  final _key = GlobalKey<FormState>();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _profileImage;
  final FocusNode _nameNode = FocusNode();
  final FocusNode _aboutNode = FocusNode();
  final FocusNode _descNode = FocusNode();
  final FocusNode _btnNode = FocusNode();
  final FocusNode _skillsNode = FocusNode();
  ImagePicker img = ImagePicker();
  bool init = true;
  String skills = '';
  Details dd = Details(
    "",
    "",
    "",
    "",
    "",
    [],
  );
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (init) {
      init = false;
      final data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        dd = data as Details;
        skills = getString(dd.skills);
      }
    }
  }

  @override
  void dispose() {
    _aboutNode.dispose();
    _skillsNode.dispose();
    _nameNode.dispose();
    _btnNode.dispose();
    _descNode.dispose();
    super.dispose();
  }

  String getString(List<String?>? list) {
    String oneStr = '';
    if (list != null) {
      for (String? i in list) {
        oneStr = '$oneStr $i';
      }
      // print(oneStr);
      return oneStr;
    }
    return oneStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
        backgroundColor: Colors.transparent,
        actions: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  focusNode: _btnNode,
                  onPressed: () {
                    onSave();
                  },
                  icon: const Icon(
                    Icons.save,
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                bottomSheet();
              },
              child: Container(
                margin: const EdgeInsets.all(
                  10,
                ),
                height: 200,
                // padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2),
                ),
                child: _profileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                          image: FileImage(
                            _profileImage!.absolute,
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(
                            image: AssetImage(
                              'Assets/Logo/profileimage.png',
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _key,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: dd.name,
                        focusNode: _nameNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "Name",
                          ),
                        ),
                        onSaved: (name) {
                          dd = Details(
                            dd.id,
                            name,
                            dd.description,
                            dd.imageUrl,
                            dd.email,
                            dd.skills,
                          );
                        },
                        validator: (name) {
                          if (name!.isEmpty) {
                            return "Provide a valid name";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_aboutNode);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _aboutNode,
                        initialValue: dd.description,
                        maxLines: null,
                        minLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "About",
                          ),
                        ),
                        validator: (dev) {
                          if (dev!.isEmpty) {
                            return "Provide a valid valid short description";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          //  FocusScope.of(context).requestFocus(_skillsNode);
                        },
                        onSaved: (about) {
                          dd = Details(
                            dd.id,
                            dd.name,
                            about,
                            dd.imageUrl,
                            dd.email,
                            dd.skills,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: _skillsNode,
                        maxLength: 50,
                        initialValue: skills.toString().trim(),
                        maxLines: null,
                        minLines: 2,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            "Skills",
                          ),
                        ),
                        onSaved: (sk) {
                          List<String?>? l = [];
                          List<String> a = sk!.split(' ').toList();
                          for (var element in a) {
                            l.add(element);
                          }
                          dd = Details(
                            dd.id,
                            dd.name,
                            dd.description,
                            dd.imageUrl,
                            dd.email,
                            l,
                          );
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_btnNode);
                        },
                        validator: (skills) {
                          if (skills!.isEmpty) {
                            return "must provide a skills ";
                          } else if (skills.length < 2) {
                            return "Provide valid skills ";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSave() async {
    bool isValid = _key.currentState!.validate();
    // print(isValid);
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      _key.currentState!.save();
      // print(dd.id);
      // print(dd.name);
      // print(dd.description);
      // print(dd.imageUrl);
      // print(dd.email);
      String? uid = _auth.currentUser!.uid;
      final data = _fireStore.collection('users').doc(uid);

      await data.update({
        'name': dd.name,
        'description': dd.description,
        'imageUrl': dd.imageUrl,
        'skills': dd.skills
      });
      Utils(
        message: 'Data Update successfully',
        color: Colors.green,
      ).showMessage();
      setState(() {
        isLoading = false;
      });
    }
  }

  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: Text(
                  'Select Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 50),
                    ),
                    onPressed: () async {
                      final imagePick = await img.pickImage(
                        source: ImageSource.camera,
                      );
                      if (imagePick != null) {
                        _profileImage = File(imagePick.path);
                        setState(() {});
                      }
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.camera,
                    ),
                    label: const Text('Camera'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 50),
                    ),
                    onPressed: () async {
                      final imagePick = await img.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (imagePick != null) {
                        _profileImage = File(
                          imagePick.path,
                        );
                        setState(() {});
                      }
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(
                      Icons.image,
                    ),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
