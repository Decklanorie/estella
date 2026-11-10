// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class SignUpResponseModel {
//   final bool success;
//   final String message;
//
//   SignUpResponseModel({required this.success, required this.message});
// }
//
// class SignUpProvider {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   // Sign up with Email and Password
//   Future<SignUpResponseModel> signUpWithPasswordProvider({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return SignUpResponseModel(success: true, message: "Sign-up successful");
//     } on FirebaseAuthException catch (e) {
//       return SignUpResponseModel(
//         success: false,
//         message: e.message ?? "An error occurred during sign-up",
//       );
//     } catch (e) {
//       return SignUpResponseModel(success: false, message: "An unexpected error occurred");
//     }
//   }
//
//   // Sign up with Google
//   Future<SignUpResponseModel> signUpWithGoogleProvider() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return SignUpResponseModel(success: false, message: "Google sign-in aborted");
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       await _firebaseAuth.signInWithCredential(credential);
//
//       return SignUpResponseModel(success: true, message: "Google sign-up successful");
//     } on FirebaseAuthException catch (e) {
//       return SignUpResponseModel(
//         success: false,
//         message: e.message ?? "An error occurred during Google sign-up",
//       );
//     } catch (e) {
//       return SignUpResponseModel(success: false, message: "An unexpected error occurred");
//     }
//   }
//
//   // Check if a user exists (by email)
//   Future<SignUpResponseModel> checkUserExistProvider({
//     required String email,
//   }) async {
//     try {
//       final List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
//
//       if (signInMethods.isNotEmpty) {
//         return SignUpResponseModel(success: true, message: "User exists");
//       } else {
//         return SignUpResponseModel(success: false, message: "User does not exist");
//       }
//     } on FirebaseAuthException catch (e) {
//       return SignUpResponseModel(
//         success: false,
//         message: e.message ?? "An error occurred while checking user existence",
//       );
//     } catch (e) {
//       return SignUpResponseModel(success: false, message: "An unexpected error occurred");
//     }
//   }
// }
