import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String actualCode;
  String status;
  PhoneVerificationCompleted verificationCompleted;
  PhoneVerificationFailed verificationFailed;
  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout;
  PhoneCodeSent codeSent;

  String _userId;


  Future<void> verifyNo(
    String phone,
  ) async{
    codeSent = (String verificationId, [int forceResendingToken]) async {
      actualCode = verificationId;
    };
    codeAutoRetrievalTimeout = (String verificationId) {
      actualCode = verificationId;
    };
    verificationFailed = (AuthException authException) {
      status = '${authException.message}';

      print("Error message: " + status);
      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      else
        status = 'Something has gone wrong, please try later';
    };

    verificationCompleted = (AuthCredential auth) {
      //_authCredential = auth;

      _firebaseAuth.signInWithCredential(auth).then((AuthResult value) {
        if (value.user != null) {
          print("Sign in Successsfull");
          _userId = value.user.uid;
//           _firestore.collection('Users').add({
//            'PhoneNumber': phone,
//            'uid': _userId,
//          });

        } else {
          print("Sign in Failed");
        }
      }).catchError((error) {});
    };

    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    notifyListeners();
    final sharedpref = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userId': _userId,
    });
    sharedpref.setString('userId', userData);
  }
}
