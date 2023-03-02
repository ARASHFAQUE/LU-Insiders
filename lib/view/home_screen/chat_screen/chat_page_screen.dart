import 'package:ashfaque_project/view/home_screen/chat_screen/chat_room_screen.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/chat_room_model.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/firebase_helper.dart';
import 'package:ashfaque_project/view/home_screen/chat_screen/controller/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bottom_nav_bar.dart';
import 'chat_room.dart';


class ChatPageScreen extends StatefulWidget {

  final String currentUser;

  ChatPageScreen({required this.currentUser});

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  /*String? currentUser;
  String nextUser;

  ChatPage({
    required this.currentUser,
    required this.nextUser,
  });*/
  //String currentUser = FirebaseAuth.instance.currentUser!.uid.toString();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteChat(ChatRoomModel chatRoom) {
    User? user = _auth.currentUser;

    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async{
                  try {
                    if (widget.currentUser == _uid) {
                      await FirebaseFirestore.instance.collection('chats').doc(widget.currentUser).collection('chat-rooms')
                          .doc(chatRoom.chatRoomId).delete();
                      await Fluttertoast.showToast(
                        msg: "Chat deleted successfully",
                        textColor: Colors.green,
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.white,
                        fontSize: 18,
                      );
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    }
                    else{
                      Fluttertoast.showToast(msg: "You cannot perform this action");
                    }
                  } catch(e){
                    Fluttertoast.showToast(msg: "This task cannot be performed");
                  } finally{}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                        Icons.delete,
                        color: Colors.red
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

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
              stream: FirebaseFirestore.instance.collection('chats').doc(widget.currentUser).collection('chat-rooms')
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
                                  height: size.height  * 0.14,
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomScreen(currentUser: widget.currentUser, targetUser: targetUser.id.toString(), chatroom: chatroomModel, name: targetUser.name.toString(), profilePic: targetUser.profilePic.toString())));
                                    },
                                    onLongPress: (){
                                      _deleteChat(chatroomModel);
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(targetUser.profilePic.toString()),
                                    ),
                                    title: Text(targetUser.name.toString()),
                                    subtitle: (chatroomModel.lastMessage.toString() != "") ? Text(chatroomModel.lastMessage.toString(), overflow: TextOverflow.visible,)
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
