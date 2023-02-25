import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/my_theme.dart';
import '../../login/login_page.dart';
import '../../welcome_page/components/custom_button.dart';
import '../bottom_nav_bar.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: BottomNavBarForApp(indexNum: 3),
      appBar: AppBar(
        title: const Text("More"),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                buttonColor: MyTheme.logInButtonColor,
                buttonText: "Log Out",
                textColor: Colors.white,
                handleButtonClick: () {
                  FirebaseAuth.instance.signOut();
                  logOutFromTheApp(context);
                }),
          ],
        ),
      ),
    );
  }

  logOutFromTheApp(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (builder)=>LogInPage()));
  }
}
