import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  String email = "";
  String password = "";
  String fullName = '';
  final authService = Authservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading?const Center(child: CircularProgressIndicator(color:Colors.deepOrangeAccent,)): SingleChildScrollView(
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
                      fullName = value;
                    });
                  },
                  validator: (value) {
                    if(value!.isNotEmpty){
                      return null;
                    }else{
                      return 'Enter your name';
                    }
                  },
                  decoration: textInputDecoration.copyWith(
                    labelText: 'fullName',
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
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: const Color(0xFFee7b64)),
                      onPressed: () {
                        register();
                      },
                      child: const Text('Register')),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Already have an account',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '  Login now',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  register()async {
    if(formkey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
  await authService.registerUserWithEmailAndPassword(fullName, email, password).then((value)async{
    if(value == true){
      await Helperfunctions.saveUserLogedInStatus(true);
      await Helperfunctions.saveUserEmailSF(email);
      await Helperfunctions.saveUserNameSF(fullName);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);

    }else{
      showSnackBar(context, Colors.red, value);
      setState(() {
        isLoading = false;
      });
    }
  });
    }
  }
}
