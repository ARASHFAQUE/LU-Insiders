// ignore_for_file: use_build_context_synchronously

import 'package:ashfaque_project/view/home_screen/job_screen/components/job_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobWidget extends StatefulWidget {

  final String jobTitle;
  final String jobDescription;
  final String jobID;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobID,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteJobPost(){
    User? user = _auth.currentUser;

    final _uemail = user!.email;
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async{
                try {
                  if (widget.uploadedBy == _uemail) {
                    await FirebaseFirestore.instance.collection("job-post-data")
                        .doc(widget.jobID).delete();
                    await Fluttertoast.showToast(
                      msg: "Post deleted successfully",
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
    return Card(
      color: Colors.white70,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: (){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => JobDetails(
            uploadedBy: widget.uploadedBy,
            jobID: widget.jobID,
          )), (route) => false);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetails(
          //   uploadedBy: widget.uploadedBy,
          //   jobID: widget.jobID,
          // )));
        },
        onLongPress: (){
          _deleteJobPost();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 2),
            )
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.jobDescription,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
