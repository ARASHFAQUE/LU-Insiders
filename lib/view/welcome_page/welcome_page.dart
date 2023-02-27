import 'package:flutter/material.dart';
import '../custom_widget/my_theme.dart';
import '../login/login_page.dart';
import '../signup/signup.dart';
import 'components/background.dart';
import 'components/custom_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
       child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("WELCOME",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.asset(
              "assets/images/undraw_Welcoming.png",
              width: size.width * 0.7,
            ),
            const SizedBox(height: 25),
            CustomButton(
              buttonColor: MyTheme.logInButtonColor,
              buttonText: "Log In",
              textColor: Colors.white,
              handleButtonClick: () {
                logInButtonClickHandler(context);
              },
            ),
            const SizedBox(height: 25),
            CustomButton(
              buttonColor: MyTheme.signUpButtonColor,
              buttonText: "Sign Up",
              textColor: Colors.white,
              handleButtonClick: (){
                signUpButtonClickHandler(context);
              },
            ),
          ],
        ),
      )),
    );
  }

  logInButtonClickHandler(BuildContext context) {
    //print("Log In Clicked");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LogInPage()), (route) => false);
    //Navigator.push(context, MaterialPageRoute(builder: (builder) => LogInPage()));
  }

  signUpButtonClickHandler(BuildContext context) {
    //print("Sign Up Clicked");
    //Navigator.push(context, MaterialPageRoute(builder: (builder)=>SignUp()));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUp()), (route) => false);
    //Navigator.push(context, MaterialPageRoute(builder: (builder)=> SignUp()));
  }
}
