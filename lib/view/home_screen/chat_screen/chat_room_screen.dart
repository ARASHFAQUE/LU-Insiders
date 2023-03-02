import 'dart:developer';

import 'package:ashfaque_project/main.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/chat_page.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/chat_page_screen.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/chat_room_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final String currentUser;
  final String targetUser;
  final String name;
  final String profilePic;
  final ChatRoomModel chatroom;

  ChatRoomScreen({
    required this.currentUser,
    required this.targetUser,
    required this.chatroom,
    required this.name,
    required this.profilePic
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != ""){
      // Send Message
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.currentUser,
        createdDate: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance.collection('chats').doc(widget.currentUser).collection('chat-rooms').doc(
          widget.chatroom.chatRoomId).collection('messages')
          .doc(newMessage.messageId).set(newMessage.toMap());

      FirebaseFirestore.instance.collection('chats').doc(widget.targetUser).collection('chat-rooms').doc(
          widget.chatroom.chatRoomId).collection('messages')
          .doc(newMessage.messageId).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection('chats').doc(widget.currentUser).collection('chat-rooms').doc(
          widget.chatroom.chatRoomId).set(widget.chatroom.toMap());

      FirebaseFirestore.instance.collection('chats').doc(widget.targetUser).collection('chat-rooms').doc(
          widget.chatroom.chatRoomId).set(widget.chatroom.toMap());

      log("Message Sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.profilePic),
              ),
              const SizedBox(width: 10),
              Text(widget.name,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){
              //print(widget.currentUser.toString());
              //Navigator.canPop(context) ? Navigator.pop(context) : null;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPageScreen(currentUser: widget.currentUser,)));
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfilePage(userID: widget.userID)));
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [

                // Takes whole area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('chats').doc(widget.currentUser).collection('chat-rooms').doc(
                          widget.chatroom.chatRoomId).collection('messages')
                          .orderBy('createdDate', descending: true)
                          .snapshots(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.active){
                          if(snapshot.hasData){
                            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                            return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index){
                                MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                                return Row(
                                  mainAxisAlignment: (currentMessage.sender == widget.currentUser)
                                      ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 3,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10
                                        ),
                                        decoration: BoxDecoration(
                                          color: (currentMessage.sender == widget.currentUser) ? Colors.purple : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(currentMessage.text.toString(),
                                          style: TextStyle(
                                            color: (currentMessage.sender == widget.currentUser) ? Colors.white : Colors.black,
                                            fontSize: 16,
                                          ),)
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          else if(snapshot.hasError){
                            return const Center(
                              child: Text("An error occurred! Please "
                                  "check you internet connection."),
                            );
                          }
                          else{
                            return const Center(
                              child: Text("Say hi to your new friend."),
                            );
                          }
                        }
                        else{
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send a Message"
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          sendMessage();
                        },
                        icon: const Icon(Icons.send, color: Colors.purple),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}