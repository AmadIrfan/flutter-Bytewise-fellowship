import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/Auth/signup_page.dart';
import 'package:flutter_firebase/model/auth_model.dart';
import 'package:provider/provider.dart';

import '../widget/round_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final _form = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          title: const Text('Login'),
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
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundButton(
                      isLoading: loading,
                      title: 'Log in',
                      onTap: () {
                        bool valid = _form.currentState!.validate();
                        if (valid) {
                          setState(() {
                            loading = true;
                          });
                          Provider.of<AuthModel>(context, listen: false).login(
                              _emailController.text,
                              _passwordController.text,
                              context);
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
                        const Text("Don't have an Account ?"),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              textBaseline: TextBaseline.alphabetic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
