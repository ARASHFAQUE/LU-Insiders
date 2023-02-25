import 'package:ashfaque_project/view/home_screen/bottom_nav_controller.dart';
import 'package:ashfaque_project/view/home_screen/job_screen/jobs_page.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        var data = snapshot.data;
        if(snapshot.data == null){
          //return const Center(child: CircularProgressIndicator());
          print("User is not logged in yet.");
          return LogInPage();
        }
        else if(snapshot.hasData){
          print("User is already logged in.");
          return const HomePage();
        }
        else if(snapshot.hasError){
          return const Scaffold(
            body: Center(
              child: Text("An error has been occurred. Try again later."),
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text("Something went wrong."),
          ),
        );
      },
    );
  }
}
