import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin GoogleSignInMixin<T extends StatefulWidget> on State<T>{
  
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();


    _googleSignIn.signIn();
    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount account) async {
    //   if (account != null) {
    //     // user logged
    //   } else {
    //     // user NOT logged
    //   }
    // });
    
    // _googleSignIn.signInSilently();
  }
}