import 'package:firebase_auth/firebase_auth.dart';
import 'package:estella/shared/data/models/response_model.dart';
import 'package:estella/features/sign_in/repository/sign_in_repository.dart';
import 'package:estella/shared/widgets/snackbar_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:estella/features/sign_up/data/models/sign_up_response_model.dart';
import 'package:estella/features/sign_up/repository/sign_up_repository.dart';
import 'package:estella/shared/widgets/snackbar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:estella/core/services/app_initializer.dart';

/// Implementation of SignInRepository
class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'https://www.googleapis.com/auth/user.birthday.read',],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ResponseModel> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final docSnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .get();
      var preLoad;

      if(docSnapshot.docs.isNotEmpty) {
        preLoad = docSnapshot.docs.first.data() as Map<String, dynamic>;
      }else{
        SnackBarService.showToast(title: "User not found");
        return ResponseModel(success: false, message: "Unsuccessful: user is null");
      }

      AppInitializer.maps.put('user',preLoad);
      AppInitializer.bools.put('isSignedIn',true);

      SnackBarService.showToast(title: 'Sign-in successful!');
      return ResponseModel(
        success: true,
        message: 'Sign-in successful!',
      );
    } on FirebaseAuthException catch (e) {
      SnackBarService.showToast(title: e.message);
      return ResponseModel(
        success: false,
        message: e.message,
      );
    } catch (e) {
      SnackBarService.showToast(title: 'An unexpected error occurred, try again later');
      return ResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<ResponseModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackBarService.showToast(title: "Google sign-in aborted");
        return ResponseModel(
            success: false, message: "Google sign-in aborted");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential res = await _firebaseAuth.signInWithCredential(credential);
      if (res.user == null) {
        SnackBarService.showToast(title: "Unsuccessful: user is null");
        return ResponseModel(success: false, message: "Unsuccessful: user is null");
      }

      final docSnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: res.user!.email)
          .get();
      var preLoad;

      if(docSnapshot.docs.isNotEmpty) {
        preLoad = docSnapshot.docs.first.data() as Map<String, dynamic>;
      }else{
        SnackBarService.showToast(title: "User not found");
        return ResponseModel(success: false, message: "Unsuccessful: user is null");
      }

      AppInitializer.maps.put('user',preLoad);
      AppInitializer.bools.put('isSignedIn',true);

      SnackBarService.showToast(title: 'Sign-in successful!');


      return ResponseModel(
        success: true,
        message: 'Google Sign-In successful!',
      );
    } on FirebaseAuthException catch (e) {
      return ResponseModel(
        success: false,
        message: e.message,
      );
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
