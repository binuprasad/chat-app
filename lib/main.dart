import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
   await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDJjUb61H9A82YWKRrfMEZPY31zrXefOEg",
            appId: "1:154883009843:web:d3630ef7c4ec3a691d6246",
            messagingSenderId: "154883009843",
            projectId: "chat-app-36d33"));
  } else {
   await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLogedInStatus();
  }

  getUserLogedInStatus() async {
    await Helperfunctions.getUserLogedInStatus().then((value) {
      if (value != null) {
        setState(() {
        isSignedIn = value;
          
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isSignedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}
