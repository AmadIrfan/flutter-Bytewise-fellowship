import 'package:cric_scorer/login_singup/custom_formfield.dart';
import 'package:cric_scorer/login_singup/login_page.dart';
import 'package:cric_scorer/login_singup/verify_email.dart';
import 'package:cric_scorer/login_singup/wavy_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
  bool isauthenticating = false;
  // Visibility of password
  // Future _passwordVisibility(passvisible) {
  //   setState(() {
  //     passvisible = !passvisible;
  //   });
  // }

  Future _createuserwithemail(useremail, userpassword) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: useremail, password: userpassword);
      //     Get.snackbar(
      // 'Signup Successful', 'Account has been created successfully');
      _email.clear();
      _password.clear();
      _confirmpass.clear();
      setState(() {
        isauthenticating = false;
      });
      Get.rawSnackbar(
        // message: e.message.toString(),
        messageText: const Text(
          'Signup successful.. verify your email',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      );
      Get.to(
        () => const verifyemail(),
        transition: Transition.leftToRight,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isauthenticating = false;
      });
      if (e.code == 'weak-password') {
        Get.snackbar('', 'Password provided is too weak.');
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('', 'Account already exists for that email.');
        // print('The account already exists for that email.');
      }
    } catch (e) {
      setState(() {
        isauthenticating = false;
      });
      Get.snackbar('', e.toString());
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
                    height: heightSize * 30 / 100,
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
                    height: heightSize * 30 / 100,
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
                    height: heightSize * 30 / 100,
                    decoration: const BoxDecoration(
                      color: Color(0xff009688),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/scorerEdgeLogo.png',
                              width: widthSize * 30 / 100,
                              height: heightSize * 11 / 100),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012,
                        ),
                        Text("Scorer Edge",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: widthSize * 5 / 100)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView(
              children: [
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
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    _password, (value) {
                  if (value!.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 8) {
                    return "Password length must be atleast 8 characters";
                  }
                }, (value) {
                  _password.text = value!;
                }, widthSize, heightSize),
                SizedBox(
                  height: heightSize * 2 / 100,
                ),
                customTextField(
                    "Confirm Password",
                    Icons.lock,
                    confirmpasswordVisible,
                    IconButton(
                      icon: Icon(
                        //choose the icon on based of passwordVisibility
                        confirmpasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          confirmpasswordVisible = !confirmpasswordVisible;
                        });
                      },
                    ),
                    _confirmpass, (value) {
                  if (value!.isEmpty) {
                    return "Please Re-Enter Your Password";
                  }
                  if (value != _password.text) {
                    return "Both Password Should Be Matched";
                  }
                }, (value) {
                  _confirmpass.text = value!;
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
                                  _createuserwithemail(_email.text.trim(),
                                      _password.text.trim());
                                }
                              },
                        child: isauthenticating
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Get Started",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: heightSize * 3 / 100),
                              ),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 5 / 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already Registered ? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: heightSize * 2 / 100,
                          fontWeight: FontWeight.normal),
                    ),
                    TextButton(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w700,
                          fontSize: heightSize * 2 / 100,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
