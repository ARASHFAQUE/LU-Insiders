import 'package:ashfaque_project/view/home_screen/job_screen/jobs_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../custom_widget/my_theme.dart';
import '../../../welcome_page/components/custom_button.dart';

class JobDetails extends StatefulWidget {

  final String uploadedBy;
  final String jobID;

  const JobDetails({
    required this.uploadedBy,
    required this.jobID,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? authorName;
  String? authorEmail;
  String? uploadedBy;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobRequirement;
  String? jobTitle;
  String? jobLocation;
  bool? recruitment;
  Timestamp? postedTimeStamp;
  Timestamp? deadlineTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;

  void getJobData() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users-form-data').doc(widget.uploadedBy).get();

    if(userDoc == null){
      return;
    }
    else{
      setState(() {
        authorName = userDoc.get('name');
        authorEmail = userDoc.get('email');
        userImageUrl = userDoc.get('profilePic');
      });
    }

    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance.collection("job-post-data")
      .doc(widget.jobID).get();

    if(jobDatabase == null){
      return;
    }
    else{
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        jobLocation = jobDatabase.get('jobLocation');
        jobRequirement = jobDatabase.get('jobRequirement');
        jobCategory = jobDatabase.get('jobCategory');
        emailCompany = jobDatabase.get('companyEmail');
        applicants = jobDatabase.get('applicants');
        postedTimeStamp = jobDatabase.get('createdAt');
        deadlineTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('jobDeadline');
        uploadedBy = jobDatabase.get('uploadedBy');

        var postDate  = postedTimeStamp!.toDate();
        postedDate = "${postDate.day}-${postDate.month}-${postDate.year}";
      });

      var date = deadlineTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  Widget dividerWidget(){
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  applyForJob(){
    final Uri params = Uri(
      scheme: "mailto",
      path: emailCompany,
      query: "subject=Applying for $jobTitle&body=Hello, please attach Resume/CV file",
    );
    final url = params.toString();
    launchUrlString(url);
    incrementApplicants();
  }
  
  void incrementApplicants() async{
    var docRef = FirebaseFirestore.instance.collection("job-post-data")
        .doc(widget.jobID);

    docRef.update({
      'applicants': applicants + 1,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      InkWell(
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: userImageUrl == null
                                      ? const AssetImage("assets/images/undraw_profile_pic.png") as ImageProvider
                                      : NetworkImage(userImageUrl!),
                                  radius: 35,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null
                                    ? "" : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    authorEmail == null
                                    ? "" : authorEmail!,
                                    style: TextStyle(color: Colors.grey.shade900))
                                ],
                              ),
                            )
                          ]
                        ),
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.uploadedBy)));
                        },
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            applicants.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            " Applicants",
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.how_to_reg_sharp,
                            color: Colors.purple,
                          )
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid.toString() != widget.uploadedBy
                      ? Container()
                      :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dividerWidget(),
                          const Text(
                            "Recruitment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: (){
                                  User? user = _auth.currentUser;
                                  final _uid = user!.uid.toString();
                                  
                                  if(_uid == widget.uploadedBy){
                                    try{
                                      FirebaseFirestore.instance.collection("job-post-data")
                                          .doc(widget.jobID).update({
                                        'recruitment': true,
                                      });
                                    }catch(e){
                                      Fluttertoast.showToast(msg: "Action cannot be performed");
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: "You cannot perform this action");
                                  }
                                  getJobData();
                                },
                                child: const Text(
                                  "ON",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: recruitment == true ? 1 : 0,
                                child: const Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 40),
                              TextButton(
                                onPressed: (){
                                  User? user = _auth.currentUser;
                                  final _uid = user!.uid.toString();

                                  if(_uid == widget.uploadedBy){
                                    try{
                                      FirebaseFirestore.instance.collection("job-post-data")
                                          .doc(widget.jobID).update({
                                        'recruitment': false,
                                      });
                                    }catch(e){
                                      Fluttertoast.showToast(msg: "Action cannot be performed");
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: "You cannot perform this action");
                                  }
                                  getJobData();
                                },
                                child: const Text(
                                  "OFF",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: recruitment == false ? 1 : 0,
                                child: const Icon(
                                  Icons.check_box,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      dividerWidget(),
                      const Text(
                        "Job Title",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        jobTitle == null
                            ? "" : jobTitle!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                      const Text(
                        "Job Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        jobCategory == null
                            ? "" : jobCategory!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                      const Text(
                        "Company's Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        emailCompany == null
                            ? "" : emailCompany!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                      const Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        jobLocation == null
                            ? "" : jobLocation!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                      const Text(
                        "Educational Requirement",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        jobRequirement == null
                            ? "" : jobRequirement!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                      const Text(
                        "Job Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        jobDescription == null
                        ? "" : jobDescription!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                          ? "Actively Recruiting, Send CV/Resume"
                          : "Deadline Passed Away",
                          style: TextStyle(
                            color: isDeadlineAvailable
                                ? Colors.green : Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                          buttonColor: MyTheme.logInButtonColor,
                          buttonText: "Apply Now",
                          textColor: Colors.white,
                          handleButtonClick: () {
                            applyForJob();
                          }),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Posted Date: "),
                          Text(
                            postedDate == null
                            ? "" : postedDate!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Deadline Date: "),
                          Text(
                            deadlineDate == null
                                ? "" : deadlineDate!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
