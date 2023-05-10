import 'package:shared_preferences/shared_preferences.dart';

class Helper{

  static String userLog="LOGGEDINKEY";
  static String username="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String UserProfile="UserProfile";

  static Future<bool> saveUserStatus(bool isUserLoggedIn) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setBool(userLog, isUserLoggedIn);
  }
  static Future<bool> saveUserName(String userName ) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(username, userName);
  }
  static Future<bool> saveUserEmail(String userEmail) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }
  static Future<bool> saveUserProfile(String uri) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(UserProfile, uri);
  }
  static Future<bool?> getUserLoggedStatus()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.getBool(userLog);
  }
  static Future<String?> getUserEmail()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.getString(userEmailKey);
  }
  static Future<String?> getUserName()async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.getString(username);
  }
   Future<String?> getUserPrrofile() async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.getString(UserProfile);
  }

}