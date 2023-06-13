import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Utils/show_message.dart';
import '../Utils/round_button.dart';
import '../model/detail_model.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

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
                      'Register',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                      label: Text("Email"),
                      hintText: 'ahmad@gmail.com',
                      filled: false,
                    ),
                    validator: (email) {
                      if (email!.isEmpty ||
                          !email.contains('@') ||
                          !email.endsWith('.com')) {
                        return "Enter an valid email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                      label: Text("Password"),
                      hintText: 'Password',
                      filled: false,
                    ),
                    validator: (password) {
                      if (password!.isEmpty || password.length < 6) {
                        return "Enter an valid Password";
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
                    title: 'Register',
                    onTap: () {
                      onSave();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Already have an account ? '),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                          );
                        },
                        child: const Text('Log In'),
                      ),
                    ],
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
    bool valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();
      setState(() {
        loading = true;
      });
      try {
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String id = _auth.currentUser!.uid;
        final userData = _store.collection('users').doc(id);
        Details d = Details(
          id,
          'dummy',
          'thi is about me',
          '',
          _auth.currentUser!.email,
          [],
        );

        await userData.set({
          'name': d.name,
          'description': d.description,
          'imageUrl': d.imageUrl,
          'skills': d.skills
        });
        Utils(message: 'Register Successfully', color: Colors.green)
            .showMessage();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Utils(message: 'The password provided is too weak', color: Colors.red)
              .showMessage();
        } else if (e.code == 'email-already-in-use') {
          Utils(
            message: 'The account already exists for that email.',
            color: Colors.red,
          ).showMessage();
        }
      } catch (e) {
        Utils(message: e.toString(), color: Colors.red).showMessage();
      }

      setState(() {
        loading = false;
      });
    }
  }
}
