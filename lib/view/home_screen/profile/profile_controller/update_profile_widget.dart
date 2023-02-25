import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../information_form/controller/info_form_up_controller.dart';

class UpdateProfileWidget extends StatefulWidget{
  final String imagePath;
  final VoidCallback onClicked;


  const UpdateProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<UpdateProfileWidget> createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  File? pickedFile;

  ImagePicker imagePicker = ImagePicker();

  InfoFormController infoFormController = Get.find();

  PlatformFile? filePicked;

  @override
  Widget build(BuildContext context) {
    const color = Colors.blue;

    return SingleChildScrollView(
      child: Center(
        child: Stack(
            children: [
              buildImage(),
              Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(color, context)
              ),
            ]
        ),
      ),
    );
  }

  Widget buildImage(){
    //print(imagePath);
    final profileImage = infoFormController.isProfilePicPathSet.value == true
        ? FileImage(File(infoFormController.profilePicPath.value)) : NetworkImage(widget.imagePath);

    // print(infoFormController.profilePicPath.value);
    // print(widget.imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: profileImage as ImageProvider,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: widget.onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color, BuildContext context) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: InkWell(
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
          size: 20,
        ),
        onTap: (){
          showModalBottomSheet(
            context: context,
            builder: (context) => bottomSheet(context),
          );
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
      final pickedImage =
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