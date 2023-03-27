import 'package:shared_preferences/shared_preferences.dart';

class Helperfunctions{
static  String userLogedInKey="userlogen";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";


  // saving data to sf
  static Future<bool>saveUserLogedInStatus(bool isUserLogedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLogedInKey,isUserLogedIn );
  }

  static Future<bool>saveUserNameSF(String userName)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey,userName );
  }

  static Future<bool>saveUserEmailSF(String userEmail)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey,userEmail );
  }


  //

  static Future<bool?>getUserLogedInStatus()async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    return pref.getBool(userLogedInKey);
  }
}