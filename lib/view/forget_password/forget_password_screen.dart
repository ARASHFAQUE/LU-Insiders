// ignore_for_file: use_build_context_synchronously

import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../custom_widget/my_theme.dart';
import '../id_password_text_fields/text_field_decorator.dart';
import '../id_password_text_fields/user_id_text_field.dart';
import '../welcome_page/components/custom_button.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final TextEditingController forgetEmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _forgetPassSubmitForm() async{
    try{
      await _auth.sendPasswordResetEmail(
          email: forgetEmailController.text,
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LogInPage()), (route) => false);
      //Navigator.push(context, MaterialPageRoute(builder: (_) => LogInPage()));
    } catch(e){
      Fluttertoast.showToast(msg: "Could Not Send Email");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        centerTitle: true,
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
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LogInPage()), (route) => false);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 110),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.1,),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Forget Password",
                    style: TextStyle(
                       color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    )),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("Email Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      )),
                ),
                const SizedBox(height: 10),
                TextFieldDecorator(
                  child: UserIdField(
                    userIdController: forgetEmailController,
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
                const SizedBox(height: 15),
                CustomButton(
                    buttonColor: MyTheme.logInButtonColor,
                    buttonText: "Reset Now",
                    textColor: Colors.white,
                    handleButtonClick: () {
                      _forgetPassSubmitForm();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
