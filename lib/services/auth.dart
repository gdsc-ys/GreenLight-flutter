import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_light/models/user.dart';

class AuthService {

  // firebase 유저 정보 받아옴
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var db = FirebaseFirestore.instance;

  // 유저 모델 커스터마이징
  GL_User? _userFromFirebaseUser(User? user){
    return user != null ? GL_User(uid: user.uid) : null;
  }

  // 유저 모델 데이터 스트리밍 전달
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
      print(e.toString());
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
        };

        db.collection("users").add(data);
      }
      // initial user data 설정 필요 -> 회원 가입시 ~~한 정보 추가~~
      
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}