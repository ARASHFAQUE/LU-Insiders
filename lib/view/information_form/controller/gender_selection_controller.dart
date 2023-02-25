import 'package:flutter/material.dart';
import 'package:get/get.dart';


class GenderSelectionController extends GetxController{
  var selectedGender = "".obs;

  onChangeGender(var gender){
    selectedGender.value = gender;
  }
}