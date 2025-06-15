import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtils {
  static const String qrSignature = 'ATTENDANCE_APP_V1_2025';
  static const String encryptionKey =
      '32-byte-secret-key-1234567890abcdef'; // 32 chars

  static final _key = encrypt.Key.fromUtf8(encryptionKey);
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static String encryptData(String data) {
    final signedData = '$qrSignature$data';
    final encrypted = _encrypter.encrypt(signedData, iv: _iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedData) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
}
