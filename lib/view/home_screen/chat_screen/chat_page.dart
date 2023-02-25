import 'package:ashfaque_project/view/home_screen/chat_screen/controller/chat_room_model.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/firebase_helper.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import 'chat_room.dart';


class ChatPage extends StatefulWidget {

  final String currentUser;

  ChatPage({required this.currentUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  /*String? currentUser;
  String nextUser;

  ChatPage({
    required this.currentUser,
    required this.nextUser,
  });*/
  //String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBarForApp(indexNum: 2),
      appBar: AppBar(
        title: const Text("Chats"),
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
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('chat-rooms')
            .where("participants.${widget.currentUser.toString()}", isEqualTo: true)
            .snapshots(),
            builder: (context, snapshot){
              print(widget.currentUser.toString());
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index){
                      //print("hello");
                      ChatRoomModel chatroomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participants = chatroomModel.participants!;

                      List<String> participantsKeys = participants.keys.toList();


                      participantsKeys.remove(widget.currentUser.toString());

                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelByID(participantsKeys[0]),
                        builder: (context, userData){
                          if(userData.connectionState == ConnectionState.done){
                            if(userData.data != null){
                              UserModel targetUser = userData.data as UserModel;

                              return Container(
                                height: size.height  * 0.1,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(currentUser: widget.currentUser, targetUser: targetUser.id.toString(), chatroom: chatroomModel, name: targetUser.name.toString(), profilePic: targetUser.profilePic.toString())));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(targetUser.profilePic.toString()),
                                  ),
                                  title: Text(targetUser.name.toString()),
                                  subtitle: (chatroomModel.lastMessage.toString() != "") ? Text(chatroomModel.lastMessage.toString())
                                  : const Text("Say hi to your new friend!",
                                  style: TextStyle(color: Colors.blue)),
                                ),
                              );
                            }
                            else{
                              return Container();
                            }
                          }
                          else{
                            return Container();
                          }
                        },
                      );
                    },
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                else{
                  return const Center(
                    child: Text("No Chats"),
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
      )
    );
  }
}
