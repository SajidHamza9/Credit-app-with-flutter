import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  late String userName;
  late String email;
  late String userId;

  Future<void> getUserInfo() async {
    try {
      userId = _auth.currentUser?.uid as String;
      email = _auth.currentUser?.email as String;
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        userName = documentSnapshot['userName'];
        notifyListeners();
      }
    } catch (error) {
      print('error');
      throw 'ERROR';
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userCredential.user?.uid).get();
      if (documentSnapshot.exists) {
        userName = documentSnapshot['userName'];
        email = documentSnapshot['email'];
        userId = documentSnapshot.id;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      throw e.message as String;
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await usersCollection
          .doc(userCredential.user?.uid)
          .set({'userName': username, 'email': email});
      userName = username;
      email = email;
      userId = userCredential.user?.uid as String;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message as String;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
