import 'package:ashfaque_project/view/home_screen/chat_screen/chat_page.dart';
import 'package:ashfaque_project/view/home_screen/more/more_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_state.dart';
import 'package:ashfaque_project/view/home_screen/search_profile/search_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'job_screen/jobs_page.dart';

class BottomNavBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavBarForApp({
    required this.indexNum
  });


  void _logOutFromApp(context){
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout, size: 36),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Sign Out", style: TextStyle(fontSize: 20)),
              )
            ],
          ),
          content: const Text(
            "Do you want to Log Out?",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text("No", style: TextStyle(fontSize: 20, color: Colors.green)),
            ),
            TextButton(
              onPressed: (){
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserState()));
              },
              child: const Text("Yes", style: TextStyle(fontSize: 20, color: Colors.green)),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: indexNum,
      color: Colors.white70,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.white,
      height: 50,
      items: const [
        Icon(Icons.home, size: 22, color: Colors.purple),
        Icon(Icons.search, size: 22, color: Colors.purple),
        Icon(Icons.message, size: 22, color: Colors.purple),
        Icon(Icons.person, size: 22, color: Colors.purple),
        //Icon(Icons.exit_to_app, size: 22, color: Colors.purple),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index == 0){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        else if(index == 1){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage()));

        }
        else if(index == 2){
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String? uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatPage(currentUser: uid.toString())));
        }

        else if(index == 3){
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String? uid = user!.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: uid)));
        }
        // else if(index == 4){
        //   _logOutFromApp(context);
        // }
      },
    );
  }
}
