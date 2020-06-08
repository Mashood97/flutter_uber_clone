import 'package:encrypt/encrypt.dart';

class SecureStorage {
  static final String KEY_PASSWORD = 'Password_key....................';

  final _key = Key.fromUtf8(KEY_PASSWORD);
  final _iv = IV.fromLength(16);

  var _encrypter;
  var _encryptedData;
  var _decryptedData;

  String encrypt(String password) {
    getAesKey(_key);
    _encryptedData = _encrypter.encrypt(password, iv: _iv);
    return _encryptedData.base64;
  }

  String decrypt(var password) {
    getAesKey(_key);
    _decryptedData = _encrypter.decrypt(password, iv: _iv);
    return _decryptedData;
  }

  Encrypted convertToEncrypt(String password){
    return Encrypted.fromBase64( password);
  }

  getAesKey(var key) {
    _encrypter = Encrypter(AES(key));
  }
}
