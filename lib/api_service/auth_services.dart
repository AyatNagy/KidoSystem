import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices{
  //static const String baseUrl = "https://kidosystem.duckdns.org/api";
  static const String baseUrl = "http://localhost:3000/api";
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleAuthServices(){
    _intitGoogleSignIn();
  }

  void  _intitGoogleSignIn(){
    const String andriodId='686443808938-jpmtgejjocnjv4r4kqenra6bl81idofq.apps.googleusercontent.com';
    const String iosId='686443808938-vfnub1ra1u9hb2oama1kn8j2ijnkaafj.apps.googleusercontent.com';

    _googleSignIn.initialize(
        clientId: andriodId,
        serverClientId: andriodId
    );

    _googleSignIn.attemptLightweightAuthentication();
  }


  Future<Map<String,dynamic>?> signinWithGoogle() async{

    final url = Uri.parse('$baseUrl/auth/google');

    try{
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();
      if (account == null) return null;
      GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) return null;

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken":idToken}),
      );

      if(response.statusCode==200){
        final data =jsonDecode(response.body);
        print("Google Login Successful: ${data['user']}");
        return data;
      } else {
        print(" Login Failed: ${response.body}");
        return null;
      }


    }catch(error){
      print("Error during Goole login: $error");
      return null;

    }
  }

}