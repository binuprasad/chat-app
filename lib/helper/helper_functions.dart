import 'package:shared_preferences/shared_preferences.dart';

class Helperfunctions{
static  String userLogedInKey="userlogen";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool?>getUserLogedInStatus()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    return pref.getBool(userLogedInKey);
  }
}