import 'package:ashfaque_project/view/home_screen/job_screen/components/job_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../job_screen/jobs_page.dart';

class JobSearch extends StatefulWidget {

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField(){
    return TextField(
      controller: _searchController,
      autocorrect: true,
      //cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Search for Job",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
        color: Colors.white
      ),
      onChanged: (query){
        updateSearchField(query);
      },
    );
  }

  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
        onPressed: (){
          _clearSearchField();
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  void _clearSearchField(){
    setState(() {
      _searchController.clear();
      updateSearchField("Search query");
    });
  }

  void updateSearchField(String newQuery){
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("job-post-data")
        .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
        .where('recruitment', isEqualTo: true).snapshots(),

        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data?.docs.isNotEmpty == true){
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index){
                  return JobWidget(
                    jobTitle: snapshot.data?.docs[index]['jobTitle'],
                    jobDescription: snapshot.data?.docs[index]['jobDescription'],
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
                child: Text("There is no jobs"),
              );
            }
          }
          return const Center(
            child: Text("Something went wrong",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          );
        },
      ),
    );
  }
}
