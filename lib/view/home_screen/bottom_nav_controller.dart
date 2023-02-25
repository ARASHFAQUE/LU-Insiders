import 'package:ashfaque_project/view/home_screen/more/more_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:ashfaque_project/view/home_screen/search_profile/search_page.dart';
import 'package:flutter/material.dart';

import 'job_screen/jobs_page.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {

  final _pages = [const HomePage(), const SearchPage(), const MorePage()];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search", backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile", backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More", backgroundColor: Colors.grey),
        ],
        onTap: (index){
          setState(() {
            pageIndex = index;
          });
        },
        currentIndex: pageIndex,
      ),
      body: _pages[pageIndex],
    );
  }
}
