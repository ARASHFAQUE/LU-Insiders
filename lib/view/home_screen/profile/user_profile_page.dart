import 'dart:developer';

import 'package:ashfaque_project/view/home_screen/bottom_nav_bar.dart';
import 'package:ashfaque_project/view/home_screen/profile/profile_controller/add_post.dart';
import 'package:ashfaque_project/view/home_screen/profile/profile_controller/edit_profile_page.dart';
import 'package:ashfaque_project/view/home_screen/profile/profile_controller/numbers_widget.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_state.dart';
import 'package:ashfaque_project/view/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../chat_screen/chat_room.dart';
import '../chat_screen/controller/chat_room_model.dart';

class UserProfilePage extends StatefulWidget {

  final String? userID;

  const UserProfilePage({required this.userID});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = "";
  String name = "";
  String phone = "";
  String company = "";
  String about = "";
  String joinedAt = "";
  String imagePath = "";
  String studentOrAlumni = "";
  String userID = "";

  bool isSameId = false;

  String _uid = FirebaseAuth.instance.currentUser!.uid;


  void getUserData() async{
    try{
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users-form-data").doc(widget.userID).get();

      if(userDoc == null){
        return;
      }
      else if(userDoc != null){
        setState(() {
          studentOrAlumni = userDoc.get("studentOrAlumni");
          name = userDoc.get('name');
          userID = userDoc.get('id');
          email = userDoc.get('email');
          phone = userDoc.get('phone');
          company = userDoc.get('company');
          about = userDoc.get('about');
          imagePath = userDoc.get('profilePic');
          Timestamp joinedTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedTimeStamp.toDate();

          joinedAt = "${joinedDate.day}-${joinedDate.month}-${joinedDate.year}";
        });
        User? user = _auth.currentUser;

        final _uid = user!.uid;

        setState(() {
          isSameId = _uid == widget.userID;
        });
      }
    } catch(e){}
  }


  Widget buildName(String userName) => Column(
    children: [
      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize:22)),
      const SizedBox(height: 10),
      const Divider(
        thickness: 2,
        color: Colors.grey,
      ),
      const SizedBox(height: 15),
    ],
  );

  Widget buildAccountInfo(String userCompany, String userEmail, String userPhone) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Information",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.business,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(userCompany, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.email,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(userEmail, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(userPhone, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    ),
  );

  Widget buildAbout(String aboutUser) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: SizedBox(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 10),
          Text(aboutUser, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void _logOutFromApp(context){
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.logout, size: 36),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Sign Out", style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            content: const Text(
              "Do you want to Sign Out?",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text("No", style: TextStyle(fontSize: 20, color: Colors.green)),
              ),
              TextButton(
                onPressed: (){
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserState()), (route) => false);
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserState()));
                },
                child: const Text("Yes", style: TextStyle(fontSize: 20, color: Colors.green)),
              )
            ],
          );
        }
    );
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

  Future<ChatRoomModel?> getChatRoomModel(String targetUser) async{
    ChatRoomModel? chatRoom;
    User? user = _auth.currentUser;

    final _uid = user!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('chat-rooms')
        .where("participants.${widget.userID}", isEqualTo: true)
        .where("participants.$_uid", isEqualTo: true).get();

    if(snapshot.docs.isNotEmpty){
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      //print(docData.toString());
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      //print(existingChatroom.chatRoomId.toString());

      chatRoom = existingChatroom;

      log("Chatroom already exists.");
    }
    else{
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userID.toString(): true,
          _uid.toString(): true,
        },
      );
      await FirebaseFirestore.instance.collection('chat-rooms').doc(newChatroom.chatRoomId)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created.");
    }
    //print(chatRoom.chatRoomId.toString());
    return chatRoom;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const color = Colors.blue;
    return Scaffold(
      bottomNavigationBar: BottomNavBarForApp(indexNum: 3),
      appBar: AppBar(
        title: const Text("Profile"),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4, bottom: 4, top: 10),
              child: Card(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      isSameId
                          ? Align(
                        alignment: Alignment.center,
                        child: Stack(
                          //alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imagePath),
                              radius: 60,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 4,
                                child: InkWell(
                                  child: GlobalMethods().buildEditIcon(color, context, userID),
                                  onTap: (){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EditProfilePage(userID: widget.userID.toString())), (route) => false);
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                                  },
                                )
                            ),
                          ],
                        ),
                      )
                          : Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(imagePath),
                          radius: 60,
                        ),
                      ),
                      const SizedBox(height: 25),
                      buildName(name),
                      const SizedBox(height: 5),
                      buildAccountInfo(company, email, phone),
                      dividerWidget(),
                      const SizedBox(height: 10),
                      buildAbout(about),
                      _uid == userID
                          ? Padding(
                        padding: EdgeInsets.only(left: size.width * 0.6),
                        child: SizedBox(
                          width: size.width * 0.3,
                          child: ClipRect(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                backgroundColor:
                                MaterialStateProperty.all(Colors.purple),
                              ),
                              onPressed: () {
                                Navigator.canPop(context) ? Navigator.pop(context) : null;
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddPost(userId: email,)));
                              },
                              child: const Text(
                                  "Add Post",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      )
                          : const Text(""),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isSameId
                    ? Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: ClipRect(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 7)),
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          _logOutFromApp(context);
                        },
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.logout, size: 36, color: Colors.white,),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),
                )
                    : Container(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}