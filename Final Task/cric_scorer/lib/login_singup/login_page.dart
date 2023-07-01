// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_scorer/customtaost.dart';
import 'package:cric_scorer/login_singup/custom_formfield.dart';
import 'package:cric_scorer/login_singup/forget_password.dart';
import 'package:cric_scorer/login_singup/signup_page.dart';
import 'package:cric_scorer/login_singup/verify_email.dart';
import 'package:cric_scorer/login_singup/wavy_design.dart';
import 'package:cric_scorer/main.dart';
import 'package:cric_scorer/user%20profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool passwordVisible = true;
  bool isauthenticating = false;
  // Visibility of password
  void _passwordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Future<dynamic> loginuserwithemail(useremail, userpassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: useremail.toString(), password: userpassword.toString());
      setState(() {
        isauthenticating = false;
      });
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Get.to(const verifyemail());
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot ds) {
          if (ds.exists) {
            Get.to(const HomePage());
            // customtoast('Login Successful');
            // _email.clear();
            // _password.clear();
          } else {
            Get.to(
              const Editprofile(),
              arguments: [
                {
                  'isedit': false,
                  'appbartitle': 'Set profile',
                  '_displayname': '',
                  '_countryname': '',
                  '_cityname': '',
                  '_profilepic':
                      'https://banner2.cleanpng.com/20180702/juw/kisspng-australia-national-cricket-team-bowling-cricket-5b39ce04df1a32.1401674715305149489138.jpg',
                },
              ],
            );
            // _email.clear();
            // _password.clear();
          }
        });
      }
      customtoast('Login Successful');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isauthenticating = false;
      });
      if (e.code == 'user-not-found') {
        Get.snackbar('Invalid user', 'No user found for that email');
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Warning!', 'Wrong password provided for that user');
        // print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WavyDesign2(),
                  child: Container(
                    width: double.infinity,
                    height: heightSize * 37 / 100,
                    decoration: const BoxDecoration(
                      color: Color(0x22009688),
                    ),
                    child: const Column(),
                  ),
                ),
                ClipPath(
                  clipper: WavyDesign3(),
                  child: Container(
                    width: double.infinity,
                    height: heightSize * 37 / 100,
                    decoration: const BoxDecoration(
                      color: Color(0x44009688),
                    ),
                    child: const Column(),
                  ),
                ),
                ClipPath(
                  clipper: WavyDesign1(),
                  child: Container(
                    width: double.infinity,
                    height: heightSize * 37 / 100,
                    decoration: const BoxDecoration(
                      color: Color(0xff009688),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/scorerEdgeLogo.png',
                              width: widthSize * 30 / 100,
                              height: heightSize * 15 / 100),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012,
                        ),
                        Text(
                          "Scorer Edge",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: heightSize * 3 / 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(children: [
                customTextField("Email", Icons.email, false, null, _email,
                    (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Please Enter Valid Email Address";
                  }
                }, (value) {
                  _email.text = value!;
                }, widthSize, heightSize),
                SizedBox(
                  height: heightSize * 2 / 100,
                ),
                customTextField(
                    "Password",
                    Icons.lock,
                    passwordVisible,
                    IconButton(
                      icon: Icon(
                        //choose the icon on based of passwordVisibility
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: _passwordVisibility,
                    ),
                    _password, (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Your Password";
                  }
                }, (value) {
                  _password.text = value!;
                }, widthSize, heightSize),
                SizedBox(
                  height: heightSize * 3 / 100,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: widthSize * 6 / 100),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Color(0xff009688)),
                      child: TextButton(
                        onPressed: isauthenticating
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isauthenticating = true;
                                  });
                                  loginuserwithemail(_email.text.trim(),
                                      _password.text.trim());
                                }
                              },
                        child: isauthenticating
                            ? const CircularProgressIndicator(
                                // backgroundColor: Colors.white,
                                color: Colors.white,
                              )
                            : Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: heightSize * 3 / 100),
                              ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8 / 100,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16))),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const ForgotPassword();
                          });
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize:
                              MediaQuery.of(context).size.height * 1.8 / 100,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4 / 100,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 5 / 100,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4 / 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an Account ? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              MediaQuery.of(context).size.height * 2 / 100,
                          fontWeight: FontWeight.normal),
                    ),
                    TextButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w700,
                          fontSize:
                              MediaQuery.of(context).size.height * 2 / 100,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                    ),
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
