import 'package:ashfaque_project/view/home_screen/search_profile/components/search_profile_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchProfileController = TextEditingController();
  String searchQuery = "Yawn";

  Widget _buildSearchField(){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextField(
        controller: _searchProfileController,
        autocorrect: true,
        //cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search by Company name",
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
      ),
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
      _searchProfileController.clear();
      updateSearchField("Yawn");
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
      bottomNavigationBar: BottomNavBarForApp(indexNum: 1),
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
        automaticallyImplyLeading: false,
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users-form-data")
            .where('company', isGreaterThanOrEqualTo: searchQuery)
            .snapshots(),

        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data!.docs.isNotEmpty){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index){
                  //String name = snapshot.data!.docs[index]['name'];
                  //String company = snapshot.data!.docs[index]['company'];
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  var currentUser = _auth.currentUser;
                  final _uid = currentUser!.uid;
                  //String? currentUser = FirebaseAuth.instance.currentUser!.email.toString();
                  return SearchProfileWidget(
                    userID: snapshot.data!.docs[index]['id'],
                    name: snapshot.data!.docs[index]['name'],
                    email: snapshot.data!.docs[index]['email'],
                    phone: snapshot.data!.docs[index]['phone'],
                    profilePic: snapshot.data!.docs[index]['profilePic'],
                    company: snapshot.data!.docs[index]['company'],
                    currentUser: _uid,
                  );
                },
              );
            }
            else{
              return const Center(
                child: Text("There is no Profile"),
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
