import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_light/models/user.dart';

class AuthService {

  // Get firebase's authentication service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var db = FirebaseFirestore.instance;

  // User model customizing
  GL_User? _userFromFirebaseUser(User? user) {
    return user != null ? GL_User(uid: user.uid) : null;
  }

  // User model data streaming transmission
  Stream<GL_User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // register email & password
  Future registerWithEmailAndPassword(
    String email, String password, String username,
    String year, String month, String day,
    String height, String weight) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (result != null) { 
        final data = {
          "nickname": username,
          "uid": user!.uid,
          "gid": null,
          "height": int.parse(height),
          "weight": int.parse(weight),
          "steps": 0,
          "date_of_birth": DateTime(int.parse(year), int.parse(month), int.parse(day)),
          "greenlight": 0,
          "reporting": 0,
          "tumbler": 0,
          "container": 0,
        };

        db.collection("users").add(data);
      }
      
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}