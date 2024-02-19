import 'dart:convert';
import 'package:steel_crypt/steel_crypt.dart';

class Aes {

  static var _key32;
  static var _iv16;

  static encAes(String plainText){
    var keyGen = CryptKey();
    //generate 32 byte key using Fortuna
    var key32 = keyGen.genFortuna(len: 32);
    //generate iv for AES
    var iv16 = keyGen.genDart(len: 16);

    var aes = AesCrypt(key: key32, padding: PaddingAES.pkcs7);
    var crypted = aes.ctr.encrypt(inp: plainText, iv: iv16);

    _key32 = key32;
    _iv16 = iv16;

    return crypted;

  }


  static denAes(String encText) {

    var iv = CryptKey().genDart(len: 16); //generate iv for AES with Dart Random.secure() //you can also enter your own

    var aes = AesCrypt(key: _key32, padding: PaddingAES.pkcs7);

    var plainText = aes.ctr.decrypt(enc: encText, iv: _iv16);

    return plainText;
  }



  //set get
   static setkey32(key32){
    _key32 = key32 ;
  }

  static getkey32(){
  return _key32 ;
  }

  static setiv16(iv16){
    _iv16 = iv16 ;
  }

  static getiv16(){
    return _iv16 ;
  }

}