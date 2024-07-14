import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech/tost.dart';
import 'package:tech/userModel.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signUpWithEmailAndPassword(
      String fullName, String email, String password, String phone) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          fullName: fullName,
          email: email,
          createdAt: DateTime.now(),
          phone: phone,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());

        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('An error occurred: ${e}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast(message: 'Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      showToast(message: 'An error occurred: ${e.code}');
    }
  }

  Future<UserModel?> getUserDetails(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user!.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      showToast(message: 'Failed to update password: ${e.message}');
    }  
    return false;
  }

// uplaod image to firebase storage
   Future<String> uploadProfileImage(String uid, XFile imageFile) async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('userProfileImages/$uid.jpg');
      final UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }
  // upload profile image
  Future<void> updateUserProfileImage(String uid, String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'pic': imageUrl});
  }

  // update userprofile
  Future<void> updateUserDetails(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

}
