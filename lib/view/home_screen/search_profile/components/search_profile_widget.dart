import 'dart:developer';

import 'package:ashfaque_project/main.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/chat_page.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/chat_room.dart';
import 'package:ashfaque_project/view/home_screen/profile/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import '../../chat_screen/controller/chat_room_model.dart';

class SearchProfileWidget extends StatefulWidget {

  final String userID;
  final String name;
  final String email;
  final String phone;
  final String profilePic;
  final String company;
  final String currentUser;

  SearchProfileWidget({
    required this.userID,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.company,
    required this.currentUser,
  });

  @override
  State<SearchProfileWidget> createState() => _SearchProfileWidgetState();
}

class _SearchProfileWidgetState extends State<SearchProfileWidget> {

  //String? currentUser = FirebaseAuth.instance.currentUser!.email;

  void _mailTo() async{
    var mailUrl = 'mailto: ${widget.email}';
    print('widget.email ${widget.email}');

    if(await canLaunchUrlString(mailUrl)){
      await canLaunchUrlString(mailUrl);
    }
    else{
      print("Error");
      throw "Error Occurred";
    }
  }

  Future<ChatRoomModel?> getChatRoomModel(String targetUser) async{
    ChatRoomModel? chatRoom;
    
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('chat-rooms')
        .where("participants.$targetUser", isEqualTo: true)
        .where("participants.${widget.currentUser}", isEqualTo: true).get();

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
          widget.currentUser.toString(): true,
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
    return Card(
      color: Colors.white70,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.email)), (route) => false);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundImage: widget.profilePic == null
            ? const AssetImage("assets/images/undraw_profile_pic.png") as ImageProvider
            : NetworkImage(widget.profilePic),
            radius: 30,
          ),
        ),
        title: Text(
          widget.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.company,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: widget.currentUser.toString() == widget.userID.toString()
          ? const Text("")
          : IconButton(
          icon: const Icon(
            Icons.message_sharp,
            size: 30,
            color: Colors.purple,
          ),
          onPressed: () async{
            //print(currentUser.toString());
            //print(widget.email);
            ChatRoomModel? chatRoomModel = await getChatRoomModel(widget.userID);
            if(chatRoomModel != null){
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(currentUser: widget.currentUser, targetUser: widget.userID, chatroom: chatRoomModel, name: widget.name, profilePic: widget.profilePic)));
            }
            //
            //_mailTo();
          },
        ),
      ),
    );
  }
}
