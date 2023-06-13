import 'package:flutter/material.dart';

import 'package:flutter_instagram/model_view/model/Auth.dart';
import 'package:flutter_instagram/model_view/model/auth_methods.dart';
import 'package:flutter_instagram/model_view/model/iuser.dart';
import 'package:flutter_instagram/view/login_view.dart';
import 'package:provider/provider.dart';

import '../res/component/input_field.dart';
import '../res/component/round_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isLoading = false;
  final _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  final FocusNode _uNameNode = FocusNode();
  final FocusNode _bioNode = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _userName.dispose();
    _bio.dispose();
    _pass.dispose();
    _passNode.dispose();
    _emailNode.dispose();
    _bioNode.dispose();
    _uNameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                          height: 60,
                          image: AssetImage(
                            'assets/images/insta.png',
                          ),
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          controler: _userName,
                          textInputType: TextInputType.text,
                          focusNode: _uNameNode,
                          label: 'User Name',
                          fieldValidator: (uN) {
                            if (uN!.toString().isEmpty) {
                              return 'User Name field is empty';
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmit: (_) {
                            FocusScope.of(context).requestFocus(_emailNode);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          controler: _email,
                          focusNode: _emailNode,
                          textInputType: TextInputType.emailAddress,
                          label: 'Email',
                          fieldValidator: (email) {
                            if (email!.toString().isEmpty) {
                              return 'Email field is empty';
                            } else if (!email.toString().contains('@') ||
                                !email.toString().endsWith('.com')) {
                              return 'Email is not Valid.';
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmit: (_) {
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
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmit: (pass) {
                            FocusScope.of(context).requestFocus(_bioNode);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputTextField(
                          controler: _bio,
                          textInputType: TextInputType.visiblePassword,
                          focusNode: _bioNode,
                          fieldValidator: (bio) {
                            if (bio!.toString().isEmpty) {
                              return 'Bio field is empty';
                            } else {
                              return null;
                            }
                          },
                          label: 'Bio',
                          onFieldSubmit: (_) {},
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        RoundButton(
                          labal: 'Sign Up',
                          onTap: () {
                            setState(
                              () {
                                _isLoading = true;
                              },
                            );
                            _onSave();
                            setState(
                              () {
                                _isLoading = false;
                              },
                            );
                          },
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: h * 0.3,
                // ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an Account ? ',
                      children: [
                        TextSpan(
                          text: 'Login',
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
      ),
    );
  }

  void _onSave() async {
    bool valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      Auth a = Auth(email: _email.text, password: _pass.text);

      IUser u = IUser(
        userId: '',
        userName: _userName.text,
        followers: [],
        following: [],
        bio: _bio.text,
        imageUrl: '',
      );
      Provider.of<AuthMethods>(
        context,
        listen: false,
      ).signUp(a, u);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
