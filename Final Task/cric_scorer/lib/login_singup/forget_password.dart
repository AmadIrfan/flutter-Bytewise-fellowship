import 'package:cric_scorer/customtaost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cric_scorer/login_singup/custom_formfield.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  bool inprogress = false;

  Future forgot_password(useremail) async {
    try {
 await FirebaseAuth.instance.sendPasswordResetEmail(email: useremail);
 setState(() {
   inprogress = false;
 });
 customtoast('Email sent');
} on FirebaseAuthException catch (e) {
  setState(() {
   inprogress = false;
 });
  Get.rawSnackbar(
    // message: e.message.toString(),
    messageText: Text(
      e.message.toString(),
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );
}
  }

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    var widthSize = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            height: heightSize * 9 / 100,
            width: widthSize,
            alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            //   color: Colors.teal,
            // ),
            child: const Text(
              "Forgot Your Password?",
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              Container(
                height: heightSize * 8 / 100,
                width: widthSize * 80 / 100,
                alignment: Alignment.center,
                child: const Text(
                  "Enter the Email address associated with your account",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: heightSize * 2 / 100,
              ),
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
                height: heightSize * 3 / 100,
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: widthSize * 6 / 100),
                  child: Container(
                    width: widthSize,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Color(0xff009688)),
                    child: TextButton(
                      child: inprogress
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Send Email",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: heightSize * 2.5 / 100),
                            ),
                      onPressed: inprogress
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  inprogress = true;
                                });
                                forgot_password(_email.text.trim());
                              }
                            },
                    ),
                  )),
              SizedBox(
                height: heightSize * 3 / 100,
              ),
              Container(
                height: heightSize * 30 / 100,
                width: heightSize * 30 / 100,
                color: Colors.transparent,
                child: Image.asset(
                  "assets/forgetPassword.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: heightSize * 3 / 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
