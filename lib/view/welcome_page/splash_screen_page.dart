import 'package:ashfaque_project/view/email_verify/verify_email.dart';
import 'package:ashfaque_project/view/information_form/form_info.dart';
import 'package:ashfaque_project/view/welcome_page/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home_screen/job_screen/jobs_page.dart';

class SplashScreenPage extends StatefulWidget {

  const SplashScreenPage({Key? key}) : super(key: key);


  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with TickerProviderStateMixin{
  late AnimationController _loadingController;

  User? loggedUser = FirebaseAuth.instance.currentUser;


  bool isEmailVerified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadingController = AnimationController(vsync: this);
    _loadingController.addListener(() {
      if(_loadingController.value > 0.9){
        _loadingController.stop();
        //Navigator.push(context, MaterialPageRoute(builder: (_)=>const WelcomePage()));
        if(loggedUser != null){
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
          if(isEmailVerified == true){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const HomePage()), (route) => false);
            //Navigator.push(context, MaterialPageRoute(builder: (_)=> const HomePage()));
          }
          else{
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const WelcomePage()), (route) => false);
            //Navigator.push(context, MaterialPageRoute(builder: (_)=> const HomePage()));
          }
        }
        else{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const WelcomePage()), (route) => false);
          //Navigator.push(context, MaterialPageRoute(builder: (_)=>const WelcomePage()));
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loadingController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
              "assets/loading-animation-3.json",
            controller: _loadingController,
            onLoaded: (composition){
                _loadingController
                    ..duration = composition.duration * 1.2
                    ..forward();
            },
          ),
          const Text("LU INSIDERS",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)
          ),
        ],
      ),
    ),
  );

}
