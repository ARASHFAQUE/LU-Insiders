import 'package:ashfaque_project/view/home_screen/chat_screen/controller/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseHelper{
  static Future<UserModel?> getUserModelByID(String uid) async{
    UserModel? userModel;

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection("users-form-data")
    .doc(uid).get();

    if(docSnapshot.data() != null){
      userModel = UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
