import 'package:ashfaque_project/view/home_screen/profile/user_state.dart';
import 'package:ashfaque_project/view/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/my_theme.dart';
import '../../persistent/persistent.dart';
import '../../welcome_page/components/custom_button.dart';
import '../bottom_nav_bar.dart';
import 'components/job_search.dart';
import 'components/job_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _jobCategoryFilter;

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
                        _jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print(
                        "jobCategoryList[index], ${Persistent.jobCategoryList[index]}"
                      );
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
                            ),
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
                    "Close",
                    style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    _jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                    "Cancel Filter",
                    style: TextStyle(fontSize: 16)),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBarForApp(indexNum: 0),
      appBar: AppBar(
        title: const Text("Job Posts"),
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
          icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
          onPressed: (){
            _showTaskCategoriesDialog(size: size);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobSearch()));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("job-post-data")
              .where('jobCategory', isEqualTo: _jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data?.docs.isNotEmpty == true) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return JobWidget(
                    jobTitle: snapshot.data?.docs[index]['jobTitle'],
                    jobDescription: snapshot.data
                        ?.docs[index]['jobDescription'],
                    jobID: snapshot.data?.docs[index]['jobID'],
                    uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                    userImage: snapshot.data?.docs[index]['userImage'],
                    name: snapshot.data?.docs[index]['name'],
                    recruitment: snapshot.data?.docs[index]['recruitment'],
                    email: snapshot.data?.docs[index]['companyEmail'],
                    location: snapshot.data?.docs[index]['jobLocation'],
                  );
                },
              );
            }
            else{
              return const Center(
                child: Text("There is no Job"),
              );
            }
          }
          return const Center(
            child: Text("Something went wrong.",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          );
        },
      ),
    );
  }
}
