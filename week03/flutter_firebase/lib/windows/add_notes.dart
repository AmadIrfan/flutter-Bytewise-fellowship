import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../utils/utils.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});
  static const routeName = '/addNotes';
  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  String id = '';
  String _title = 'Add Notes';
  bool init = false;
  bool _loading = false;
  Map<String, dynamic> _temp = {};
  @override
  void didChangeDependencies() {
    if (!init) {
      final data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        _temp = data as Map<String, dynamic>;
        _textEditingController.text = _temp['text'].toString();
        _titleEditingController.text = _temp['title'].toString();
        id = _temp['id'].toString();
        _title = 'Update Notes';
      }
    }
    init = true;
    super.didChangeDependencies();
  }

  final Uuid _uid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              final ref = FirebaseDatabase.instance.ref('Post/$uid');
              if (id == '') {
                DateTime dateTime = DateTime.now();
                String uId = _uid.v1();
                await ref.child(uId).set({
                  'id': uId,
                  'title': _titleEditingController.text,
                  'text': _textEditingController.text,
                  'dateTime': dateTime.toIso8601String(),
                });
                Utils().resultMessage('Saved');
              } else {
                ref.child(id).update({
                  'title': _titleEditingController.text,
                  'text': _textEditingController.text,
                });
                Utils().resultMessage('Updated');
              }
              setState(() {
                _loading = false;
              });
            },
            icon: _loading
                ? const CircularProgressIndicator()
                : Icon(id.isEmpty ? Icons.save : Icons.update),
          ),
        ],
        title: Text(_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            TextFormField(
              style: const TextStyle(
                fontSize: 30,
              ),
              controller: _titleEditingController,
              decoration: const InputDecoration(
                label: Text(
                  "title",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _textEditingController,
              maxLines: null,
              style: const TextStyle(
                fontSize: 30,
              ),
              decoration: const InputDecoration(
                label: Text(
                  "Body",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
