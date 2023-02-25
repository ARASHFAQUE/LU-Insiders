// ignore_for_file: use_build_context_synchronously

import 'package:ashfaque_project/view/home_screen/job_screen/jobs_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_state.dart';
import 'package:ashfaque_project/view/id_password_text_fields/global_form_text_field.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../../custom_widget/my_theme.dart';
import '../../../id_password_text_fields/text_field_decorator.dart';
import '../../../persistent/persistent.dart';
import '../../../signup/components/signup_background.dart';
import '../../../welcome_page/components/custom_button.dart';

class AddPost extends StatefulWidget {
  final String userId;

  const AddPost({required this.userId});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;

  String? name = "";
  String userImage = "";

  TextEditingController jobCategoryController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController deadlineDateController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController jobRequirementController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    jobCategoryController.dispose();
    jobTitleController.dispose();
    jobLocationController.dispose();
    jobDescriptionController.dispose();
    deadlineDateController.dispose();
    companyEmailController.dispose();
    jobRequirementController.dispose();
  }

  Widget _textTitles({required String label}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  _showTaskCategoriesDialog({required Size size}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Job Category",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    setState(() {
                      jobCategoryController.text = Persistent.jobCategoryList[index];
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
                        child: Text(
                          Persistent.jobCategoryList[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                          )
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16)),
            )
          ],
        );
      }
    );
  }

  void _pickDateDialog() async{
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );

    if(picked != null){
      setState(() {
        deadlineDateController.text = "${picked!.day}-${picked!.month}-${picked!.year}";
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);

      });
    }
  }

  void _sendJobPostsToDB() async{
    final jobID = const Uuid().v4();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    final _uid = currentUser!.uid;
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      String jobCat = "Job Category";
      String jobDeadline = "Deadline Date(D-M-Y)";
      String jobTitle = "Job Title";
      String jobDescription = "Job Description";
      String jobLocation = "Job Location";
      String companyEmail = "Company Email";
      String jobRequirement = "Job Requirement";
      if(jobCategoryController.text == jobCat || deadlineDateController.text == jobDeadline
      || jobTitleController.text == jobTitle || jobDescriptionController.text == jobDescription
      || jobLocationController.text == jobLocation || companyEmailController.text == companyEmail
      || jobRequirementController.text == jobRequirement){
        Fluttertoast.showToast(msg: "Please Pick Everything");
      }
      try{
        CollectionReference collectionRef = FirebaseFirestore.instance.collection("job-post-data");
        collectionRef.doc(jobID).set({
          "jobID": jobID,
          "uploadedBy": _uid,
          "companyEmail": companyEmailController.text,
          "jobCategory": jobCategoryController.text,
          "jobRequirement": jobRequirementController.text,
          "jobTitle": jobTitleController.text,
          "jobDescription": jobDescriptionController.text,
          "jobLocation": jobLocationController.text,
          "jobDeadline": deadlineDateController.text,
          "deadlineDateTimeStamp": deadlineDateTimeStamp,
          "jobComments": [],
          "recruitment" : true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "applicants": 0
        });
        await Fluttertoast.showToast(msg: "Task has been completed.");

        jobCategoryController.clear();
        jobTitleController.clear();
        jobDescriptionController.clear();
        jobLocationController.clear();
        deadlineDateController.clear();
        
        setState(() {
          jobCategoryController.text = jobCat;
          jobTitleController.text = jobTitle;
          jobLocationController.text = jobLocation;
          jobDescriptionController.text = jobDescription;
          deadlineDateController.text = jobDeadline;
        });
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: _uid)));
      } catch(e){
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    else{
      print("It's not valid.");
    }
  }

  void getMyData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      name = userDoc.get("name");
      userImage = userDoc.get("profilePic");
    });
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Post"),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final User? user = _auth.currentUser;
            final String _uid = user!.uid;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: user.uid)));
          },
        ),
      ),
      body: SignUpBackground(
        child: Center(
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 100.0),
                    child: Text("Please Fill All Fields",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Job Category",
                                  controller: jobCategoryController,
                                  enabled: false,
                                  fct: (){
                                    _showTaskCategoriesDialog(size: size);
                                  },
                                  maxLines: 1,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Job Category",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.category,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Job Title",
                                  controller: jobTitleController,
                                  enabled: true,
                                  fct: (){

                                  },
                                  maxLines: 1,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Job Title",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.title,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Job Location",
                                  controller: jobLocationController,
                                  enabled: true,
                                  fct: (){

                                  },
                                  maxLines: 1,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Job Location",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.location_pin,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Company Email",
                                  controller: companyEmailController,
                                  enabled: true,
                                  fct: (){

                                  },
                                  maxLines: 1,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Company Email",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.email,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Job Requirement",
                                  controller: jobRequirementController,
                                  enabled: true,
                                  fct: (){

                                  },
                                  maxLines: 3,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Job Requirement",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.description,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Job Description",
                                  controller: jobDescriptionController,
                                  enabled: true,
                                  fct: (){

                                  },
                                  maxLines: 5,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Job Description",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.description,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          TextFieldDecorator(
                              child: GlobalFormTextField(
                                  valueKey: "Deadline Date",
                                  controller: deadlineDateController,
                                  enabled: false,
                                  fct: (){
                                    _pickDateDialog();
                                  },
                                  maxLines: 1,
                                  jobErrorText: "Can Not Be Empty",
                                  jobHintText: "Deadline Date(D-M-Y)",
                                  jobHintTextColor: Colors.purple,
                                  jobTextFieldPrefixIcon: Icons.timer,
                                  jobTextFieldPrefixIconColor: Colors.purple,
                                  inputType: TextInputType.text)),
                          const SizedBox(height: 10),
                          CustomButton(
                              buttonColor: MyTheme.signUpButtonColor,
                              buttonText: "Post",
                              textColor: Colors.white,
                              handleButtonClick: () {
                                _sendJobPostsToDB();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
