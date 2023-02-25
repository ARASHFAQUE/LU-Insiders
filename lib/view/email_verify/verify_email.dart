import 'dart:async';

import 'package:ashfaque_project/view/information_form/form_info.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../custom_widget/my_theme.dart';
import '../welcome_page/components/custom_button.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose(){
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async{
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? FormInfo()
      : Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "A verification email has been sent to your email.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center
              ),
              const SizedBox(height: 25),
              CustomButton(
                buttonColor: MyTheme.logInButtonColor,
                buttonText: "Resent Email",
                textColor: Colors.white,
                handleButtonClick: () {
                  canResendEmail ? sendVerificationEmail() : null;
                }
              ),
              const SizedBox(height: 10),
              CustomButton(
                buttonColor: MyTheme.signUpButtonColor,
                buttonText: "Cancel",
                textColor: Colors.white,
                handleButtonClick: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LogInPage()), (route) => false);
                  //Navigator.push(context, MaterialPageRoute(builder: (_)=>LogInPage()));
                }
              ),
            ],
          ),
        ),
      );

}
