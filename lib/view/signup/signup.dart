import 'package:ashfaque_project/view/email_verify/verify_email.dart';
import 'package:ashfaque_project/view/id_password_text_fields/password_field.dart';
import 'package:ashfaque_project/view/id_password_text_fields/text_field_decorator.dart';
import 'package:ashfaque_project/view/id_password_text_fields/user_id_text_field.dart';
import 'package:ashfaque_project/view/information_form/form_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ashfaque_project/view/custom_widget/my_theme.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:ashfaque_project/view/signup/components/signup_background.dart';
import 'package:ashfaque_project/view/welcome_page/components/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../welcome_page/welcome_page.dart';

//import '../phone_verify/verify_phone.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var phone = "";

  passwordsCheck(BuildContext context) {
    if (passwordController.text.contains(' ') ||
        confirmPasswordController.text.contains(' ')) {
      Fluttertoast.showToast(msg: "Space is not allowed.");
    } else if (passwordController.text.length < 8 &&
        confirmPasswordController.text.length < 8) {
      Fluttertoast.showToast(
          msg: "Password must contain at least 8 characters.");
    } else if (passwordController.text.length >= 8 &&
        confirmPasswordController.text.length < 8) {
      Fluttertoast.showToast(msg: "Passwords Don't Match!!");
    } else if (passwordController.text.length < 8 &&
        confirmPasswordController.text.length >= 8) {
      Fluttertoast.showToast(msg: "Passwords Don't Match!!");
    } else if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Passwords Don't Match!!");
    } else if (passwordController.text == confirmPasswordController.text) {
      userSignUp(context);
    }
  }

  userSignUp(context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>FormInfo()), (route) => false);

        Navigator.push(context, MaterialPageRoute(builder: (_) => FormInfo()));
        // await FirebaseAuth.instance.verifyPhoneNumber(
        //   phoneNumber: "+88${phone}",
        //   verificationCompleted: (PhoneAuthCredential credential) {},
        //   verificationFailed: (FirebaseAuthException e) {},
        //   codeSent: (String verificationId, int? resendToken) {
        //     SignUp.verify = verificationId;
        //     Navigator.push(context, MaterialPageRoute(builder: (_)=>PhoneNumberVerify()));
        //   },
        //   codeAutoRetrievalTimeout: (String verificationId) {},
        // );
      } else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  // userSignUp(context) async{
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text,
  //         password: passwordController.text
  //     );
  //     var authCredential = userCredential.user;
  //
  //     //print(authCredential!.uid);
  //
  //     if(authCredential!.uid.isNotEmpty){
  //
  //       await FirebaseAuth.instance.verifyPhoneNumber(
  //         phoneNumber: "+88${phone}",
  //         verificationCompleted: (PhoneAuthCredential credential) {},
  //         verificationFailed: (FirebaseAuthException e) {},
  //         codeSent: (String verificationId, int? resendToken) {
  //           SignUp.verify = verificationId;
  //           Navigator.push(context, MaterialPageRoute(builder: (_)=>PhoneNumberVerify()));
  //         },
  //         codeAutoRetrievalTimeout: (String verificationId) {},
  //       );
  //
  //     }
  //     else{
  //       Fluttertoast.showToast(msg: "Something is wrong");
  //     }
  //
  //
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       Fluttertoast.showToast(msg: "The password provided is too weak.");
  //     } else if (e.code == 'email-already-in-use') {
  //       Fluttertoast.showToast(msg: "The account already exists for that email.");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, 0.9],
          )),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
                (route) => false);
            //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)), (route) => false);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
          },
        ),
      ),
      body: SignUpBackground(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/undraw_signup.png",
                width: size.width * 0.6),
            const Text("Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            const SizedBox(height: 10),
            TextFieldDecorator(
                child: UserIdField(
                    userIdController: emailController,
                    maxLines: 1,
                    userIdErrorText: "Please enter a valid Email address.",
                    userIdHintText: "Enter Email",
                    inputType: TextInputType.emailAddress,
                    userIdHintTextColor: Colors.purple,
                    userIdTextFieldPrefixIcon: Icons.email,
                    userIdTextFieldPrefixIconColor: Colors.purple,
                    onUserIdValueChange: (value) {})),
            TextFieldDecorator(
                child: UserPassField(
              userPassController: passwordController,
              userPassErrorText: "Password must have at least 8 characters.",
              userPassHintText: "Enter Password",
              inputType: TextInputType.visiblePassword,
              userPassHintTextColor: Colors.purple,
              userPassTextFieldPrefixIcon: Icons.password,
              userPassTextFieldPrefixIconColor: Colors.purple,
              suffixIcon: Icons.visibility_off,
              suffixIconColor: Colors.purple,
              onUserPassValueChange: (value) {
                //print("Pass Value $value");
              },
            )),
            TextFieldDecorator(
                child: UserPassField(
              userPassController: confirmPasswordController,
              userPassErrorText: "Password must have at least 8 characters.",
              userPassHintText: "Re-enter Password",
              inputType: TextInputType.visiblePassword,
              userPassHintTextColor: Colors.purple,
              userPassTextFieldPrefixIcon: Icons.password,
              userPassTextFieldPrefixIconColor: Colors.purple,
              suffixIcon: Icons.visibility_off,
              suffixIconColor: Colors.purple,
              onUserPassValueChange: (value) {
                //print("Pass Value $value");
              },
            )),
            const SizedBox(height: 10),
            CustomButton(
                buttonColor: MyTheme.signUpButtonColor,
                buttonText: "Sign Up",
                textColor: Colors.white,
                handleButtonClick: () {
                  passwordsCheck(context);
                }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                InkWell(
                  child: const Text("Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.purple)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => LogInPage()));
                  },
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
