import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/model/Auth.dart';
import 'package:flutter_instagram/model_view/model/auth_methods.dart';
import 'package:flutter_instagram/res/component/input_field.dart';
import 'package:flutter_instagram/res/component/round_button.dart';
import 'package:flutter_instagram/view/signup_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Form(
                key: _form,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/images/insta.png',
                        ),
                        height: 60,
                        color: Colors.purple,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextField(
                        controler: _email,
                        focusNode: _emailNode,
                        textInputType: TextInputType.emailAddress,
                        label: 'Email',
                        fieldValidator: (e) {
                          if (e!.toString().isEmpty) {
                            return 'Email field is empty';
                          } else if (!e.toString().contains('@') ||
                              !e.toString().endsWith('.com')) {
                            return 'Email is not Valid.';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmit: (email) {
                          FocusScope.of(context).requestFocus(_passNode);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextField(
                        controler: _pass,
                        textInputType: TextInputType.visiblePassword,
                        focusNode: _passNode,
                        label: 'Password',
                        fieldValidator: (pass) {
                          if (pass!.toString().isEmpty) {
                            return 'password field is empty';
                          }
                          return null;
                        },
                        onFieldSubmit: (pass) {
                          // FocusScope.of(context).requestFocus(_passNode);
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: const Text.rich(
                            TextSpan(
                              text: 'Forget Password',
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      RoundButton(
                        isLoading: _isLoading,
                        labal: 'Log In',
                        onTap: () {
                          _onSave();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: h * 0.3,
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Create an Account ?',
                    children: [
                      TextSpan(
                        text: 'SignUp',
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() async {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Auth auth = Auth(email: _email.text, password: _pass.text);
      Provider.of<AuthMethods>(context, listen: false).logIn(auth, context);

      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }
}
