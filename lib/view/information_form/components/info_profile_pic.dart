import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';

import '../../services/global_methods_photo.dart';
import '../controller/info_form_up_controller.dart';

class InfoFormProfilePic extends StatefulWidget {
  InfoFormProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<InfoFormProfilePic> createState() => _InfoFormProfilePicState();
}

class _InfoFormProfilePicState extends State<InfoFormProfilePic> {
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();

  InfoFormController infoFormController = Get.find();
  PlatformFile? filePicked;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const color = Colors.blue;
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(() => CircleAvatar(
              backgroundImage: infoFormController.isProfilePicPathSet.value ==
                      true
                  ? FileImage(File(infoFormController.profilePicPath.value))
                      as ImageProvider
                  : const AssetImage("assets/images/undraw_profile_pic.png"),
              radius: 60,
            )),
        Positioned(
            bottom: 0,
            right: 4,
            child: InkWell(
              child: GlobalMethodsPhoto().buildEditIcon(color, context),
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: (context) => bottomSheet(context),
                );
              },
            )
        ),
      ],
    );
  }

  Widget bottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          const Text("Choose Profile Picture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, color: Colors.purple),
                    SizedBox(height: 10),
                    Text("Gallery",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple))
                  ],
                ),
                onTap: () {
                  //print("Gallery");
                  takePicture(ImageSource.gallery);
                },
              ),
              const SizedBox(width: 50),
              InkWell(
                child: Column(
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.deepPurple),
                    SizedBox(height: 10),
                    Text("Camera",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple))
                  ],
                ),
                onTap: () {
                  //print("Camera");
                  takePicture(ImageSource.camera);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> takePicture(ImageSource imageSource) async {
    try{
      XFile? pickedImage =
      await imagePicker.pickImage(source: imageSource, imageQuality: 100);


      pickedFile = File(pickedImage!.path);
      infoFormController.setProfileImagePath(pickedFile!.path);

      Get.back();
    } on PlatformException catch(e){
      Fluttertoast.showToast(msg: "Failed to pick image.");
    }
    //print(pickedFile);
  }
}
