import 'dart:io';

import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UpdateFormController extends GetxController{

  var isProfilePicPathSet = false.obs;
  var profilePicPath = "".obs;

  void updateProfileImagePath(String path){
    profilePicPath.value = path;
    isProfilePicPathSet.value = true;
    notifyChildrens();
  }
}