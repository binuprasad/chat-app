import 'package:chat_app/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String adminName;
  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      members = value;
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String r) {
    return r.substring(0, r.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Group Info'),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        widget.groupName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Groupname:${widget.groupName}",
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Admin:${widget.adminName}")
                      ],
                    )
                  ],
                ),
              ),
              memberList(),
            ],
          ),
        ));
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                        leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        getName(snapshot.data['members'][index])
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(getName(snapshot.data['members'][index])),
                    subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            }else{
              return const Center(child: Text('No Members'),);
            }
          } else {
            return const Center(
              child: Text('NO MEMBERS'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }
}
