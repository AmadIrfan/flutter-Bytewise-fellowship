// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/show_message.dart';
import '../Utils/round_button.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Form(
              key: _form,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Center(
                    child: Text(
                      'Verify Email',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                      label: Text("Email"),
                      hintText: 'ahmad@gmail.com',
                      filled: false,
                    ),
                    validator: (email) {
                      if (email!.isEmpty) {
                        return "Please provide a valid Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundButton(
                    loading: loading,
                    title: 'Send',
                    onTap: () {
                      onSave();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSave() async {
    setState(() {
      loading = true;
    });
    if (_form.currentState!.validate()) {
      try {
        _form.currentState!.save();
        await _auth.currentUser!.sendEmailVerification();
        Utils(
                message: 'Check you mailbox email has been sent',
                color: Colors.red)
            .showMessage();
      } on FirebaseAuthException catch (e) {
        Utils(message: e.toString(), color: Colors.red).showMessage();
      } catch (e) {
        Utils(message: e.toString(), color: Colors.red).showMessage();
      }
    }
    setState(() {
      loading = false;
    });
  }
}
