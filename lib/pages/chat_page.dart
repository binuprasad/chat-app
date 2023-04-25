import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin='';
@override
void initState() {
  super.initState();
  getChatAndAdmin();
  
}
  getChatAndAdmin(){
    DatabaseService().getChat(widget.groupId).then((value){
      setState(() {
        chats= value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        chats = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: widget.userName,
                  ),
                ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
