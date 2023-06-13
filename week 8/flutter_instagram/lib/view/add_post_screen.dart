// ignore_for_file: unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram/model_view/firestore_methods.dart';
import 'package:flutter_instagram/model_view/model/iuser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../model_view/provider/user_provider.dart';
import '../res/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _file;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _desController = TextEditingController();
  bool _postLoading = false;

  Future<void> _selectImage(BuildContext context) {
    ImagePicker imagePicker = ImagePicker();
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from Gallery...'),
            onPressed: () async {
              Navigator.of(context).pop(true);
              final pImage =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (pImage != null) {
                setState(
                  () {
                    _file = File(
                      pImage.path,
                    );
                  },
                );
              }
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Click From Camera...'),
            onPressed: () async {
              Navigator.of(context).pop(true);
              final cImage =
                  await imagePicker.pickImage(source: ImageSource.camera);
              if (cImage != null) {
                setState(
                  () {
                    _file = File(
                      cImage.path,
                    );
                  },
                );
              }
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }

  void postPost(IUser? u) async {
    try {
      setState(() {
        _postLoading = true;
      });
      FireStoreMethost pro =
          Provider.of<FireStoreMethost>(context, listen: false);
      String imgPath = await pro.uploadPost(
        'Posts',
        File(
          _file!.path,
        ),
      );
      pro.postPost(u, _desController.text, imgPath);
      setState(() {
        _postLoading = false;
      });
      clearImage();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      setState(() {
        _postLoading = false;
      });
    }
  }

  void clearImage() {
    _file = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final pUser = Provider.of<UserProvider>(context, listen: false);
    pUser.refreshUser();
    pUser.getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectImage(
                  context,
                );
              },
              icon: const Icon(
                Icons.upload,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              title: const Text(
                'Add Post',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    postPost(pUser.getUser);
                  },
                  child: const Text(
                    'Post',
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _postLoading
                    ? const LinearProgressIndicator()
                    : Container(
                        color: mobileBgColor,
                        width: double.infinity,
                        height: 5,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: FileImage(
                        File(_file!.path),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: TextField(
                        controller: _desController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption.....',
                          border: InputBorder.none,
                        ),
                        // maxLines: 7,
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                _file as File,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
