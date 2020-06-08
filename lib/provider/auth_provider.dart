import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../utils/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/flutter_secure_storage.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final SecureStorage _secureStorage = SecureStorage();
  String _countryCode;

  String _mobileNo;
  String _userid;
  String _userName;
  String _cityName;
  String _email;

  bool get getAutoLogin => _userid != null;

  String get getuserEmail => _email;

  String get getCountryCode => _countryCode;

  String get getMobileNo => _mobileNo;

  String get getUserId => _userid;

  String get getUserName => _userName;

  String get getCityName => _cityName;

  String verificationId;

  Future<void> verifyPhone(String countryCode, String mobile) async {
    var mobileToSend = mobile;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: mobileToSend,
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(
            seconds: 120,
          ),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            throw exceptio;
          });
      _countryCode = countryCode;
      _mobileNo = mobile;
    } catch (e) {
      throw e;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final AuthResult user =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      print(user);

      print(currentUser.uid);
      if (currentUser.uid != "") {
        _userid = currentUser.uid;
      }
    } catch (e) {
      throw e;
    }
  }

  showError(error) {
    throw error.toString();
  }

  Future<void> addUserData(
      String name, String cityName, String password, String email) async {
    try {
      String getPassword = _secureStorage.encrypt(password);

      print('the encrypted password is: $getPassword');
      await _firestore.collection('RegisteredUser').add({
        'username': name,
        'userid': _userid,
        'countrycode': _countryCode,
        'mobileNo': _mobileNo,
        'cityName': cityName,
        'password': getPassword,
        'email': email,
      });

      _userName = name;
      _cityName = cityName;
      _email = email;
      notifyListeners();
      final authData = json.encode({
        'userid': _userid,
        'username': _userName,
        'phoneNo': _mobileNo,
        'city': _cityName,
        'countryCode': _countryCode,
        'password': getPassword,
        'email': email
      });
      await SharedPref.init();

      await SharedPref.setAuthdata(authData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> autoLogin() async {
    await SharedPref.init();
    String abc = SharedPref.getAuthData();
    // if (abc == null || abc.isEmpty) {
    //   return false;
    // }
    final extractedData = json.decode(abc) as Map<String, Object>;
    if (extractedData == null || extractedData.isEmpty) {
      return false;
    }

    _userName = extractedData['username'];
    _userid = extractedData['userid'];
    _mobileNo = extractedData['phoneNo'];
    _countryCode = extractedData['countryCode'];
    _cityName = extractedData['city'];
    _email = extractedData['email'];

    notifyListeners();
    return true;
  }

  void logout() async {
    _userid = null;
    _userName = null;
    _cityName = null;
    _countryCode = null;
    _mobileNo = null;
    notifyListeners();
    await SharedPref.init();
    SharedPref.clearSharedPrefData();
  }

  Future<void> signinWithEmailandPassword(String email, String password) async {
    try {
      await _firestore
          .collection('RegisteredUser')
          .where('email', isEqualTo: email)
          .getDocuments()
          .then((value) {
        if (value.documents.isNotEmpty) {
          Map<String, dynamic> documentData = value.documents.single.data;
//          print();

          String getPassword = _secureStorage.decrypt(
              _secureStorage.convertToEncrypt(documentData['password']));
          print(getPassword);
          print(documentData['email']);
        }
        else{
          throw Error();
        }
      }).catchError((e) => throw e);
    } catch (e) {
      throw e;
    }
  }
}
