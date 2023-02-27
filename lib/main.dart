import 'package:ashfaque_project/view/custom_widget/my_theme.dart';
import 'package:ashfaque_project/view/home_screen/bottom_nav_controller.dart';
import 'package:ashfaque_project/view/home_screen/job_screen/jobs_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_state.dart';
import 'package:ashfaque_project/view/information_form/form_info.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:ashfaque_project/view/signup/signup.dart';
import 'package:ashfaque_project/view/welcome_page/splash_screen_page.dart';
import 'package:ashfaque_project/view/welcome_page/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: const SplashScreenPage(),
    );
  }
}




