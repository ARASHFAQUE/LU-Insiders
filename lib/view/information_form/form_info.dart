import 'dart:io';

import 'package:ashfaque_project/view/email_verify/verify_email.dart';
import 'package:ashfaque_project/view/id_password_text_fields/more_info.dart';
import 'package:ashfaque_project/view/information_form/controller/gender_selection_controller.dart';
import 'package:ashfaque_project/view/information_form/controller/info_form_up_controller.dart';
import 'package:ashfaque_project/view/signup/signup.dart';
import 'package:ashfaque_project/view/welcome_page/splash_screen_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../custom_widget/my_theme.dart';
import '../home_screen/bottom_nav_controller.dart';
import '../home_screen/job_screen/jobs_page.dart';
import '../id_password_text_fields/global_form_text_field.dart';
import '../id_password_text_fields/text_field_decorator.dart';
import '../id_password_text_fields/user_id_text_field.dart';
import '../persistent/persistent.dart';
import 'components/info_profile_pic.dart';
import '../signup/components/signup_background.dart';
import '../welcome_page/components/custom_button.dart';

class FormInfo extends StatefulWidget {
  String signUpEmail;
  String signUpPassword;

  FormInfo({required this.signUpEmail, required this.signUpPassword});

  @override
  State<FormInfo> createState() => _FormInfoState();
}

class _FormInfoState extends State<FormInfo> {
  TextEditingController alumniOrStudentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  GenderSelectionController genderSelectionController =
      Get.put(GenderSelectionController());

  InfoFormController infoFormController = Get.put(InfoFormController());
  InfoFormProfilePic infoFormProfilePic = InfoFormProfilePic();
  DateTime? pickedDate;
  String? _alumniOrStudent;

  final _formKey = GlobalKey<FormState>();

  void numberValidation(BuildContext context){
    if(!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(mobileController.text)){
      Fluttertoast.showToast(msg: "Enter a Valid Phone Number");
    }
    else{
      userSignUp(context);
    }
  }


  userSignUp(context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.signUpEmail, password: widget.signUpPassword);

      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        sendUserDataToDB();
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>FormInfo()), (route) => false);

        //Navigator.push(context, MaterialPageRoute(builder: (_) => FormInfo()));
        // await FirebaseAuth.instance.verifyPhoneNumber(
        //   phoneNumber: "+88${phone}",
        //   verificationCompleted: (PhoneAuthCredential credential) {},
        //   verificationFailed: (FirebaseAuthException e) {},
        //   codeSent: (String verificationId, int? resendToken) {
        //     SignUp.verify = verificationId;
        //     Navigator.push(context, MaterialPageRoute(builder: (_)=>PhoneNumberVerify()));
        //   },
        //   codeAutoRetrievalTimeout: (String verificationId) {},
        // );
      } else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  sendUserDataToDB() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("ProfilePic")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask =
        ref.putFile(File(infoFormController.profilePicPath.value));

    TaskSnapshot snapShot = await uploadTask;
    String imageDwnUrl = await snapShot.ref.getDownloadURL();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    final _uid = currentUser!.uid;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionRef
        .doc(_uid)
        .set(
          {
            "id": _uid,
            "email": currentUser.email,
            "studentOrAlumni": alumniOrStudentController.text,
            "name": nameController.text,
            "phone": mobileController.text,
            "dob": birthDateController.text,
            "gender": genderSelectionController.selectedGender.value,
            "company": companyController.text,
            "about": aboutController.text,
            "profilePic": imageDwnUrl,
            "createdAt": Timestamp.now(),
          },
        )
        .then((value) => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => VerifyEmail()), (route) => false))
        .catchError((error) => print("Something is wrong"));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    alumniOrStudentController.dispose();
    mobileController.dispose();
    birthDateController.dispose();
    genderSelectionController.dispose();
    companyController.dispose();
    aboutController.dispose();
  }

  void _pickDateDialog() async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text =
            "${pickedDate!.day}-${pickedDate!.month}-${pickedDate!.year}";
      });
    }
  }

  _showStudentOrAlumniDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Student or Alumni?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.alumniOrCurrent.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        alumniOrStudentController.text =
                            Persistent.alumniOrCurrent[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        // const Icon(
                        //   Icons.arrow_right_alt,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(Persistent.alumniOrCurrent[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text("Cancel", style: TextStyle(fontSize: 16)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Form"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, 0.9],
          )),
        ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUp()), (route) => false);
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)), (route) => false);
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
            },
          )
      ),
      body: SignUpBackground(
        child: Card(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  InfoFormProfilePic(),
                  TextFieldDecorator(
                      child: GlobalFormTextField(
                          valueKey: "Alumni Student",
                          controller: alumniOrStudentController,
                          enabled: false,
                          fct: () {
                            _showStudentOrAlumniDialog(size: size);
                          },
                          maxLines: 1,
                          jobErrorText: "Can Not Be Empty",
                          jobHintText: "Student or Alumni",
                          jobHintTextColor: Colors.purple,
                          jobTextFieldPrefixIcon: Icons.category,
                          jobTextFieldPrefixIconColor: Colors.purple,
                          inputType: TextInputType.text)),
                  TextFieldDecorator(
                      child: UserIdField(
                          userIdController: nameController,
                          maxLines: 1,
                          userIdErrorText: "Name Can Not Be Empty",
                          userIdHintText: "Enter Name",
                          inputType: TextInputType.name,
                          userIdHintTextColor: Colors.purple,
                          userIdTextFieldPrefixIcon: Icons.person,
                          userIdTextFieldPrefixIconColor: Colors.purple,
                          onUserIdValueChange: (value) {})),
                  TextFieldDecorator(
                      child: UserIdField(
                          userIdController: mobileController,
                          maxLines: 1,
                          userIdErrorText: "Phone No. Can Not Be Empty",
                          userIdHintText: "Enter Phone Number",
                          inputType: TextInputType.phone,
                          userIdHintTextColor: Colors.purple,
                          userIdTextFieldPrefixIcon: Icons.phone,
                          userIdTextFieldPrefixIconColor: Colors.purple,
                          onUserIdValueChange: (value) {})),
                  TextFieldDecorator(
                      child: GlobalFormTextField(
                          valueKey: "Deadline Date",
                          controller: birthDateController,
                          enabled: false,
                          fct: () {
                            _pickDateDialog();
                          },
                          maxLines: 1,
                          jobErrorText: "Date of Birth can not be empty",
                          jobHintText: "Date of Birth(D-M-Y)",
                          jobHintTextColor: Colors.purple,
                          jobTextFieldPrefixIcon: Icons.date_range,
                          jobTextFieldPrefixIconColor: Colors.purple,
                          inputType: TextInputType.datetime)),
                  TextFieldDecorator(
                      child: UserIdField(
                          userIdController: companyController,
                          maxLines: 1,
                          userIdErrorText: "Company Name",
                          userIdHintText: "Company Name",
                          inputType: TextInputType.text,
                          userIdHintTextColor: Colors.purple,
                          userIdTextFieldPrefixIcon: Icons.business,
                          userIdTextFieldPrefixIconColor: Colors.purple,
                          onUserIdValueChange: (value) {})),
                  TextFieldDecorator(
                      child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text("Gender",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple)),
                        ),
                        Row(
                          children: [
                            Obx(() => Radio(
                                  value: "Male",
                                  groupValue: genderSelectionController
                                      .selectedGender.value,
                                  onChanged: (value) {
                                    genderSelectionController
                                        .onChangeGender(value);
                                  },
                                  activeColor: Colors.purple,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.purple),
                                )),
                            const Text("Male",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple)),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(() => Radio(
                                  value: "Female",
                                  groupValue: genderSelectionController
                                      .selectedGender.value,
                                  onChanged: (value) {
                                    genderSelectionController
                                        .onChangeGender(value);
                                  },
                                  activeColor: Colors.purple,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.purple),
                                )),
                            const Text("Female",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple)),
                          ],
                        )
                      ],
                    ),
                  )),
                  TextFieldDecorator(
                      child: UserIdField(
                          userIdController: aboutController,
                          userIdErrorText: "User Info",
                          userIdHintText: "Write About Yourself",
                          maxLines: 5,
                          inputType: TextInputType.multiline,
                          userIdHintTextColor: Colors.purple,
                          userIdTextFieldPrefixIcon: Icons.description,
                          userIdTextFieldPrefixIconColor: Colors.purple,
                          onUserIdValueChange: (value) {})),
                  const SizedBox(height: 10),
                  CustomButton(
                      buttonColor: MyTheme.signUpButtonColor,
                      buttonText: "Continue",
                      textColor: Colors.white,
                      handleButtonClick: () async {
                        //uploadProfilePicture();
                        //FormInfo.isFilled = true;
                        //img.value = await infoFormController.sendUserPicToDB();
                        //sendUserDataToDB();
                        userSignUp(context);
                      }),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

// continueButtonClick(){
//   Navigator.push(context, MaterialPageRoute(builder: (builder)=>HomeScreen()));
// }
}
