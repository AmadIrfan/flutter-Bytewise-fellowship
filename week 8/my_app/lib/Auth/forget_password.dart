import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/show_message.dart';
import '../Utils/round_button.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
                      'Forget Password',
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
                        return "Enter an valid Email";
                      } else {
                        return null;
                      }
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
        await _auth.sendPasswordResetEmail(email: _emailController.text);
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
