import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/model/auth_model.dart';
import 'package:provider/provider.dart';

import '../widget/round_button.dart';
import 'login_page.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final _form = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
          title: const Text('Login with Phone Number'),
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                        label: Text("Phone"),
                        hintText: '+92 340 0123456',
                        filled: false,
                      ),
                      validator: (email) {
                        if (!email!.contains('') && !email.contains('.com')) {
                          return 'Provide correct Phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
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
                          Provider.of<AuthModel>(context, listen: false)
                              .loginWithMobile(_phoneController.text, context);
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Login with Email'),
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
