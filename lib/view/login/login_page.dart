import 'package:ashfaque_project/view/email_verify/verify_email.dart';
import 'package:ashfaque_project/view/forget_password/forget_password_screen.dart';
import 'package:ashfaque_project/view/home_screen/job_screen/jobs_page.dart';
import 'package:ashfaque_project/view/id_password_text_fields/text_field_decorator.dart';
import 'package:ashfaque_project/view/id_password_text_fields/user_id_text_field.dart';
import 'package:ashfaque_project/view/welcome_page/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ashfaque_project/view/custom_widget/my_theme.dart';
import 'package:ashfaque_project/view/login/components/login_background.dart';
import 'package:ashfaque_project/view/welcome_page/components/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home_screen/bottom_nav_controller.dart';
import '../id_password_text_fields/password_field.dart';
import '../signup/signup.dart';

class LogInPage extends StatefulWidget {

  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool isEmailVerified = false;

  final FocusNode _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  TextEditingController userIdController = TextEditingController();
  TextEditingController passController = TextEditingController();



  userSignIn() async{


    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userIdController.text,
          password: passController.text
      );
      var authCredential = userCredential.user;
      //print(authCredential!.uid);
      if(authCredential!.uid.isNotEmpty){
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        if(isEmailVerified){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (_)=>VerifyEmail()));
        }
      }
      else{
        Fluttertoast.showToast(msg: "Something is wrong");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
      //print(e);
    }
  }

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
              )
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
            //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)), (route) => false);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
          },
        ),
      ),
     body: LogInBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/Login.png"),
            const Text("Log In",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldDecorator(
                    child: UserIdField(
                      userIdController: userIdController,
                      maxLines: 1,
                      userIdErrorText: "Please enter a valid Email address.",
                      userIdHintText: "Enter Email",
                      userIdHintTextColor: Colors.purple,
                      userIdTextFieldPrefixIcon: Icons.person,
                      userIdTextFieldPrefixIconColor: Colors.purple,
                      inputType: TextInputType.emailAddress,
                      onUserIdValueChange: (value) {
                        //print(value);
                      },
                    ),
                  ),
                  TextFieldDecorator(
                      child: UserPassField(
                    userPassController: passController,
                    userPassErrorText: "Please enter a valid Password.",
                    userPassHintText: "Enter Password",
                    userPassHintTextColor: Colors.purple,
                    userPassTextFieldPrefixIcon: Icons.password,
                    inputType: TextInputType.visiblePassword,
                    userPassTextFieldPrefixIconColor: Colors.purple,
                    suffixIcon: Icons.visibility_off,
                    suffixIconColor: Colors.purple,
                    onUserPassValueChange: (value) {
                      //print("Pass Value $value");
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        child: const Text("Forgot Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                      buttonColor: MyTheme.logInButtonColor,
                      buttonText: "Log In",
                      textColor: Colors.white,
                      handleButtonClick: () {
                        userSignIn();
                      }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        child: const Text("Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        onTap: (){
                          //print("Sign Up Tapped");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  // logInWithInfo(BuildContext context){
  //   Navigator.push(context, MaterialPageRoute(builder: (builder)=> HomeScreen()));
  // }
}
