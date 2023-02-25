import 'dart:io';

import 'package:ashfaque_project/view/home_screen/profile/profile_controller/update_form_controller.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../custom_widget/my_theme.dart';
import '../../../id_password_text_fields/text_field_decorator.dart';
import '../../../id_password_text_fields/user_id_text_field.dart';
import '../../../services/global_methods_photo.dart';
import '../../../signup/components/signup_background.dart';
import '../../../welcome_page/components/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  String userID;

  EditProfilePage({
    required this.userID,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();

  UpdateFormController updateFormController = Get.put(UpdateFormController());
  PlatformFile? filePicked;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  String profilePicture = "";
  bool pictureTaken = false;
  String email = "";

  editProfile(data, BuildContext context){
    email = FirebaseAuth.instance.currentUser!.email.toString();
    String name = data['name'];
    String phone = data['phone'];
    String company = data['company'];
    String about = data['about'];
    profilePicture = data['profilePic'];

    nameController.text = name;
    mobileController.text = phone;
    companyController.text = company;
    aboutController.text = about;
    const color = Colors.blue;

    return SignUpBackground(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Card(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Obx(() => CircleAvatar(
                          backgroundImage: updateFormController.isProfilePicPathSet.value == true ?
                          FileImage(File(updateFormController.profilePicPath.value)) as ImageProvider : NetworkImage(profilePicture),
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
                    ),
                    const SizedBox(height: 20),
                    TextFieldDecorator(
                        child: UserIdField(
                            userIdController: nameController,
                            maxLines: 1,
                            userIdErrorText: "Name Can Not Be Empty",
                            userIdHintText: name,
                            inputType: TextInputType.name,
                            userIdHintTextColor: Colors.black,
                            userIdTextFieldPrefixIcon: Icons.person,
                            userIdTextFieldPrefixIconColor: Colors.purple,
                            onUserIdValueChange: (value) {})),
                    TextFieldDecorator(
                        child: UserIdField(
                            userIdController: mobileController,
                            maxLines: 1,
                            userIdErrorText: "Phone No.",
                            userIdHintText: phone,
                            inputType: TextInputType.phone,
                            userIdHintTextColor: Colors.black,
                            userIdTextFieldPrefixIcon: Icons.phone,
                            userIdTextFieldPrefixIconColor: Colors.purple,
                            onUserIdValueChange: (value) {})),
                    TextFieldDecorator(
                        child: UserIdField(
                            userIdController: companyController,
                            maxLines: 1,
                            userIdErrorText: "Company Name",
                            inputType: TextInputType.text,
                            userIdHintText: company,
                            userIdHintTextColor: Colors.black,
                            userIdTextFieldPrefixIcon: Icons.business,
                            userIdTextFieldPrefixIconColor: Colors.purple,
                            onUserIdValueChange: (value) {})),
                    TextFieldDecorator(
                        child: UserIdField(
                            userIdController: aboutController,
                            maxLines: 5,
                            userIdErrorText: "User Info",
                            inputType: TextInputType.multiline,
                            userIdHintText: about,
                            userIdHintTextColor: Colors.black,
                            userIdTextFieldPrefixIcon: Icons.description,
                            userIdTextFieldPrefixIconColor: Colors.purple,
                            onUserIdValueChange: (value) {})),
                    const SizedBox(height: 20),
                    CustomButton(
                        buttonColor: MyTheme.logInButtonColor,
                        buttonText: "Save",
                        textColor: Colors.white,
                        handleButtonClick: () async{
                          updateUserDataToDB();
                          //updateProfilePicture();
                          //img.value = await infoFormController.sendUserPicToDB();
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
      final pickedImage =
      await imagePicker.pickImage(source: imageSource, imageQuality: 100);

      pictureTaken = true;
      pickedFile = File(pickedImage!.path);
      updateFormController.updateProfileImagePath(pickedFile!.path);

      Get.back();
    } on PlatformException catch(e){
      Fluttertoast.showToast(msg: "Failed to pick image.");
    }
    //print(pickedFile);
  }

  updateUserDataToDB() async{

    if(pictureTaken == true){
      Reference ref = FirebaseStorage.instance.ref().child("ProfilePic").child(FirebaseAuth.instance.currentUser!.uid);

      UploadTask uploadTask = ref.putFile(File(updateFormController.profilePicPath.value));

      TaskSnapshot snapShot = await uploadTask;
      String imageDwnUrl = await snapShot.ref.getDownloadURL();
      profilePicture = imageDwnUrl;
    }
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(widget.userID).update({
      "name": nameController.text,
      "phone": mobileController.text,
      "company": companyController.text,
      "about": aboutController.text,
      "profilePic": profilePicture,
    },
    ).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=> UserProfilePage(userID: widget.userID)))).catchError(
            (error)=>print("Something is wrong"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
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
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)), (route) => false);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
          },
        ),
      ),
      body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users-form-data").doc(widget.userID).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              var data = snapshot.data;
              if(data == null){
                return const Center(child: CircularProgressIndicator());
              }
              return editProfile(data, context);
            },
          )),
    );
  }
}
