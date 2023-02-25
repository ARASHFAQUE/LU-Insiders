import 'package:flutter/material.dart';

import '../home_screen/profile/profile_controller/edit_profile_page.dart';

class GlobalMethods{
  Widget buildEditIcon(Color color, BuildContext context, String userID) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: InkWell(
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(userID: userID)));
        },
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) => ClipOval(
    child: Container(
      padding: EdgeInsets.all(all),
      color: color,
      child: child,
    ),
  );

}
