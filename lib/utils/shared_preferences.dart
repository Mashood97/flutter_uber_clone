import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String auth_key_shared_pref = 'authDatas';

  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefs;
  static SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static Future<bool> setAuthdata(String authdata) async {
    return _prefsInstance.setString(auth_key_shared_pref, authdata) ??
        Future.value(false);
  }

  static String getAuthData([String defValue]) {
    String authData= _prefsInstance.getString(auth_key_shared_pref);

    if(authData != null && authData.isNotEmpty)
    {
      return authData;
    }
    return '{}';
  }

  static void clearSharedPrefData() {
    _prefsInstance.clear();
  }

// static String getUserType() {
//   String abc = getAuthData();
//   final getdata = json.decode(abc) as Map<String, Object>;
//   if (getdata == null) {
//     return 'Not Found';
//   }
//   String userType = getdata['userType'];
//   return userType;
// }
}