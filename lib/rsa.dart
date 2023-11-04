import 'dart:convert';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:steel_crypt/steel_crypt.dart';


class Aes {

  static encryptAes(String plainText){
    var keyGen = CryptKey();
    //generate 32 byte key using Fortuna
    var key32 = keyGen.genFortuna(len: 32);
    //generate 16 byte key using Fortuna
    var key16 = keyGen.genFortuna(len: 16);
    //generate iv for AES
    var iv16 = keyGen.genDart(len: 16);
    //generate iv for ChaCha20
    var iv8 = keyGen.genDart(len: 8);

    var iv = CryptKey().genDart(len: 16); //generate iv for AES with Dart Random.secure() //you can also enter your own
   // var aesEncrypter = AesCrypt(FortunaKey, 'cbc', 'pkcs7'); //generate AES CBC block encrypter with key and PKCS7 padding
    //var aes = AesCrypt(key: key32, padding: PaddingAES.pkcs7);
    //var crypted2 = aes.ctr.encrypt(inp: plainText, iv: iv16);


    var aes = AesCrypt(key: "GkV/OPHTEaxZjNy5kpLYgjpvSNtTetmQJi9Z5fw26Y8=", padding: PaddingAES.pkcs7);
    var crypted2 = aes.ctr.encrypt(inp: plainText, iv: "c1LkfcUtEg/hHiyR0fbOKQ==");


    //Encrypt.
    //var aaa = aes.ctr.decrypt(enc: crypted2, iv: iv16);

    print(crypted2);
    print(aes.ctr.decrypt(enc: crypted2, iv: "c1LkfcUtEg/hHiyR0fbOKQ==")); //Decrypt.
    print(crypted2);

   // return aaa;

    return crypted2;

  }


  static dencryptAes(String plainText) {
    var keyGen = CryptKey();
    //generate 32 byte key using Fortuna
    var key32 = keyGen.genFortuna(len: 32);
    //generate 16 byte key using Fortuna
    var key16 = keyGen.genFortuna(len: 16);
    //generate iv for AES
    var iv16 = keyGen.genDart(len: 16);
    //generate iv for ChaCha20
    var iv8 = keyGen.genDart(len: 8);

    var iv = CryptKey().genDart(len: 16); //generate iv for AES with Dart Random.secure() //you can also enter your own
    //var aes = AesCrypt(key: key32, padding: PaddingAES.pkcs7);

    //var crypted2 = aes.ctr.decrypt(enc: plainText, iv: iv16); //Encrypt.

    var aes = AesCrypt(key: "GkV/OPHTEaxZjNy5kpLYgjpvSNtTetmQJi9Z5fw26Y8=", padding: PaddingAES.pkcs7);

    var aaa = aes.ctr.decrypt(enc: plainText, iv: "c1LkfcUtEg/hHiyR0fbOKQ==");

    //print(crypted2);
    //print(aes.ctr.decrypt(enc: aaa, iv: "c1LkfcUtEg/hHiyR0fbOKQ==")); //Decrypt.


    return aaa;
  }

}