import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  Future updateUserData(String fullName, String email) async {
    return userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //------creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": '',
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessege": "",
      "recentMessegeSender": "",
    });
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(
        ["${uid}_$userName"],
      ),
      "groupId": groupDocumentReference.id,
    });
    DocumentReference userDocumentReference =userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName'])
    });
  }
}
