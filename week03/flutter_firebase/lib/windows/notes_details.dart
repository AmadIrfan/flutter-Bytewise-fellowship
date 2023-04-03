import 'package:flutter/material.dart';

import 'add_notes.dart';

class NotesDetails extends StatefulWidget {
  const NotesDetails({super.key});
  static const routName = '/NotesDetails';
  @override
  State<NotesDetails> createState() => _NotesDetailsState();
}

class _NotesDetailsState extends State<NotesDetails> {
  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddNotes.routeName,
                arguments: {
                  'title': data['title'],
                  'id': data['id'],
                  'text': data['text'],
                },
              );
            },
            icon: const Icon(Icons.update_sharp),
            tooltip: 'Update',
          ),
        ],
        title: Text(
          data['title'] == '' ? 'No Title' : data['title'],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextFormField(
              style: const TextStyle(
                fontSize: 30,
              ),
              initialValue: data['title'],
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
              initialValue: data['text'],
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
