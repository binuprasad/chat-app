import 'package:chat_app/pages/registerscreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Grupie',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Login now to see what they are talking!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  Image.asset('asset/chatloginimg.jpg'),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(
                      labelText: 'email',
                      prefix: const Icon(
                        Icons.mail,
                        color: Color(0xFFee7b64),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: 'password',
                      prefix: const Icon(
                        Icons.lock,
                        color: Color(0xFFee7b64),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 25
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: const Color(0xFFee7b64)),
                        onPressed: () {},
                        child: const Text('Sign in')),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'dont have an account?',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                            text: ' register here',
                            recognizer: TapGestureRecognizer()..onTap=(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Register(),));
                            } )
                      ],
                    ),
                  )
                ],
              ),),
        ),
      ),
    );
  }
}
