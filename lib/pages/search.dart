import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = '';
  bool isJoined = false;
  User ?user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName()async{
    await Helperfunctions.getUserNameSF().then((value){
      setState(() {
        userName= value!;
      });
    });
    user= FirebaseAuth.instance.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Search',
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.red,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search groups....',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 17)),
                  )),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red.withOpacity(0.2)),
                    ),
                  )
                ],
              ),
            ),
            isLoading? Center(child: CircularProgressIndicator(color: Colors.red,)):groupList(),

          ],
        ));
  }
  initiateSearchMethod()async{
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading=true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot){
        setState(() {
          isLoading= false;
          searchSnapshot=snapshot;
          hasUserSearched= true;
        });

      });
    }
  }
  groupList(){
    return hasUserSearched ? ListView.builder(
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return groupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['admin'],
          searchSnapshot!.docs[index]['groupName']
        );
      },
    ):Container();
  }

  joinedOrNot(String userName,String groupId,String admin,String groupName)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });
  }
  Widget groupTile(String userName,String groupId,String admin,String groupName){
    joinedOrNot(userName,groupId,admin,groupName);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical:5 ,horizontal: 10),
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 30,
        child: Text(groupName.substring(0,1),style: TextStyle(color: Colors.white),),
      ),
    );

  }
}
