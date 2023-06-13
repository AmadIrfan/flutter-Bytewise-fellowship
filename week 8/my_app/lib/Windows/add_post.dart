// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/show_message.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? _image;
  bool loading = false;

  // firebase_storage.FirebaseStorage _storage =
  //     firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth _user = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  final FocusNode _btnFocus = FocusNode();
  final TextEditingController _bodyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _bodyFocus.dispose();
    _titleFocus.dispose();
    _btnFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                pickImage();
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                // alignment: Alignment.center,
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green.shade100,
                    width: 4,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _image != null
                      ? Image(
                          image: FileImage(_image!.absolute),
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage('Assets/Logo/logo.png'),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        focusNode: _titleFocus,
                        controller: _titleController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          label: Text('Title'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (title) {
                          if (title!.isEmpty) {
                            return 'Title Field not be Empty';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_bodyFocus);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: null,
                        minLines: 5,
                        focusNode: _bodyFocus,
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          label: Text('body'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (title) {
                          // if (title!.isEmpty) {
                          //   return 'Title Field not be Empty';
                          // }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_btnFocus);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          onSave();
                        },
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text('Post'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSave() async {
    //firebase firestore collection

    String url = "";
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      try {
        String postUserId = _user.currentUser!.uid;
        String date = DateTime.now().toIso8601String();
        Uuid uuid = const Uuid();
        String blogId = uuid.v1();
        final blog = _firestore.collection('Blog');
        final user = _firestore
            .collection('users')
            .doc(postUserId)
            .collection('UserPostedIdes');

        setState(() {
          loading = true;
        });
        //firebase store reference
        if (_image != null) {
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('User Posts/$postUserId/Blog Posts/' '$blogId');
          //uploading images
          firebase_storage.UploadTask uploadTask =
              ref.putFile(_image!.absolute);
          await Future.value(uploadTask);

          //getting download url
          url = await ref.getDownloadURL();
        }
        // Details d = Details('dummy', 'thi is about me', '', []);
        // final userData = _firestore.collection('users').doc(postUserId);
        // await userData.set({
        //   'name': d.name,
        //   'description': d.description,
        //   'imageUrl': d.imageUrl,
        //   'skills': d.skills
        // });
        //uploading blog data
        await blog.doc(blogId).set(
          {
            'userId': postUserId,
            'postId': blogId,
            'title': _titleController.text,
            'body': _bodyController.text,
            'dateTime': date,
            'updatedTime': date,
            'imagePost': url,
          },
        );

        await user.doc(blogId).set(
          {
            'blogPostId': blogId,
          },
        );
        Utils(
          message: 'successfully Posted',
        ).showMessage();
        setState(() {
          loading = false;
        });
      } catch (e) {
        Utils(message: '$e').showMessage();
        setState(() {
          loading = false;
        });
      }
    }
  }

  pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
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
                  'Select Image',
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
                      ImagePicker picker = ImagePicker();
                      final pickedImage = await picker.pickImage(
                        source: ImageSource.camera,
                        maxHeight: 350,
                        maxWidth: double.infinity,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
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
                      ImagePicker picker = ImagePicker();
                      final pickedImage = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 350,
                        maxWidth: double.infinity,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
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

// showDialog(
//   context: context,
//   builder: (context) => AlertDialog(
//     title: const Text(
//       'Select Image :',
//       textAlign: TextAlign.center,
//     ),
//     content: SizedBox(
//       height: 100,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               TextButton.icon(
//                 onPressed: () async {
//                   ImagePicker picker = ImagePicker();
//                   final pickedImage =
//                       await picker.pickImage(source: ImageSource.camera);
//                   setState(() {
//                     _image = File(pickedImage!.path);
//                   });
//                   Navigator.pop(context, true);
//                 },
//                 icon: Icon(
//                   Icons.camera,
//                 ),
//                 label: Text('Camera'),
//               ),
//               TextButton.icon(
//                 onPressed: () async {
//                   ImagePicker picker = ImagePicker();
//                   final pickedImage =
//                       await picker.pickImage(source: ImageSource.gallery);
//                   setState(() {
//                     _image = File(pickedImage!.path);
//                   });
//                   Navigator.pop(context, true);
//                 },
//                 icon: Icon(
//                   Icons.image,
//                 ),
//                 label: Text('Gallery'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   ),
// );
