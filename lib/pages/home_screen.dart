import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/grouptile.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Authservice authservice = Authservice();
  String userName = '';
  String email = '';
  Stream? group;
  bool _isLosding = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();

    gettingUserData();
  }

  //string manipulation-------------

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await Helperfunctions.getUserEmailSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await Helperfunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ));
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text(
          'Groups',
          style: TextStyle(
              fontSize: 29, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[500],
            ),
            Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.red,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.group,
                color: Colors.red,
              ),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    email: email,
                    userName: userName,
                  ),
                ));
              },
              selectedColor: Colors.red,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.group,
                color: Colors.grey,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await authservice.signOut().whenComplete(() =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false));
                            },
                            child: const Text('Logout')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  },
                );
              },
              selectedColor: Colors.red,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLosding == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLosding = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLosding = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: group,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getname(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              )),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from the top search button",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
