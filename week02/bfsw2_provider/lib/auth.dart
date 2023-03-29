import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Auth/auth_provider.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'field id empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'field id empty';
                      }
                      return null;
                    }),
                ElevatedButton(
                  onPressed: onSave,
                  child: const Text('Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSave() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false)
          .login(emailController.text, passwordController.text);
    }
  }
}
