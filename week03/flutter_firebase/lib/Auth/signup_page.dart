import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/Auth/login_page.dart';
import 'package:flutter_firebase/model/auth_model.dart';

import 'package:provider/provider.dart';

import '../widget/round_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  bool loading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool value = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit'),
            content: const Text(
              'Are you sure you want to exit ?',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
            ],
          ),
        );
        if (value) {
          SystemNavigator.pop();
          return false;
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _form,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                        label: Text("Email"),
                        hintText: 'ahmad@gmail.com',
                        filled: false,
                      ),
                      validator: (email) {
                        if (!email!.contains('@') && !email.contains('.com')) {
                          return 'Provide correct email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text("Password"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                        hintText: 'Password',
                      ),
                      validator: (password) {
                        if (password!.length < 6) {
                          return 'Password must be greater then 6';
                        } else if (password !=
                            _confirmPasswordController.text) {
                          return 'Password must be similar to the confirm password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text("Confirm Password"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                        hintText: 'Confirm Password',
                      ),
                      validator: (password) {
                        if (password!.length < 6) {
                          return 'Password must be greater then 6 and similar ';
                        } else if (password != _passwordController.text) {
                          return 'Password must be similar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                      title: 'Sign up',
                      isLoading: loading,
                      onTap: () {
                        bool valid = _form.currentState!.validate();
                        if (valid) {
                          setState(() {
                            loading = true;
                          });
                          Provider.of<AuthModel>(context, listen: false).signUp(
                              _emailController.text, _passwordController.text);

                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("already have an Account ?"),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              textBaseline: TextBaseline.alphabetic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
