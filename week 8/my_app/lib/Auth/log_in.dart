import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/Auth/sign_up.dart';

import '../Utils/round_button.dart';
import '../Utils/show_message.dart';
import '../Windows/my_home_page.dart';
import 'forget_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool loading = false;
  final _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                      'Log In',
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
                    title: 'Log In',
                    onTap: () {
                      onSave();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPassword(),
                            ),
                          );
                        },
                        child: const Text('Forget Password'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account ? '),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },
                            child: const Text('Sign up'),
                          ),
                        ],
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
    setState(() {
      loading = true;
    });
    if (_form.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Utils(message: "login Successfully", color: Colors.green).showMessage();

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Utils(message: 'No user found for that email.', color: Colors.red)
              .showMessage();
        } else if (e.code == 'wrong-password') {
          Utils(
                  message: 'Wrong password provided for that user.',
                  color: Colors.red)
              .showMessage();
        }
      } catch (e) {
        Utils(message: e.toString(), color: Colors.red).showMessage();
      }
    }
    setState(() {
      loading = false;
    });
  }
}
