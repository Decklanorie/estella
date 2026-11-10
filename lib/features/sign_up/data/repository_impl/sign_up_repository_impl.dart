import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:estella/features/sign_up/data/models/sign_up_response_model.dart';
import 'package:estella/features/sign_up/repository/sign_up_repository.dart';
import 'package:estella/shared/widgets/snackbar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:estella/core/services/app_initializer.dart';


class SignUpRepositoryImpl implements SignUpRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'https://www.googleapis.com/auth/user.birthday.read',],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<SignUpResponseModel> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {

      SignUpResponseModel checkUserExist = await this.checkUserExist(email: email);
      print(checkUserExist.success);
      if (checkUserExist.success == false || checkUserExist.userExist == true) {
        SnackBarService.showToast(title: checkUserExist.message);
        return SignUpResponseModel(success: false, message: checkUserExist.message ?? '');
      }
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot wpDetailsSnapshot = await _firestore.collection('wpDetails')
          .where('user_email', isEqualTo: email)
          .get();
      Map<String, dynamic> wpDetails = {};
      if(wpDetailsSnapshot.docs.isNotEmpty) {
        wpDetails = wpDetailsSnapshot.docs.first.data() as Map<String, dynamic>;
      }
      final docRef = _firestore.collection('users')
          .doc();
      var preLoad = {
        'id': docRef.id,
        'email': email,
        'fullName': fullName,
        'wpDetails': wpDetails ?? {},
        'readStories':[]
      };
      var load = {
        ...preLoad,
        'createdAt': FieldValue.serverTimestamp().toString(),
        'updatedAt': FieldValue.serverTimestamp().toString(),
      };
      await docRef.set(load);

      AppInitializer.maps.put('user',preLoad);
      AppInitializer.bools.put('isSignedIn',true);
      SnackBarService.showToast(title: "Sign-up successful");
      return SignUpResponseModel(success: true, message: "Sign-up successful");
    } on FirebaseAuthException catch (e) {
      SnackBarService.showToast(
        title: e.message ?? "An error occurred during sign-up",);
      return SignUpResponseModel(
        success: false,
        message: e.message ?? "An error occurred during sign-up",
      );
    } catch (e) {
      print(e);
      SnackBarService.showToast(title: "An unexpected error occurred");
      return SignUpResponseModel(success: false, message: "An unexpected error occurred");
    }
  }

  @override
  Future<SignUpResponseModel> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackBarService.showToast(title: "Google sign-in aborted");
        return SignUpResponseModel(
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
        return SignUpResponseModel(success: false, message: "Unsuccessful: user is null");
      }
      QuerySnapshot wpDetailsSnapshot = await _firestore.collection('wpDetails')
          .where('user_email', isEqualTo: res.user!.email)
          .get();
      Map<String, dynamic> wpDetails = {};
      if(wpDetailsSnapshot.docs.isNotEmpty) {
        wpDetails = wpDetailsSnapshot.docs.first.data() as Map<String, dynamic>;
      }
      String? dob = await this.getUserProfile(credential.accessToken ?? '');

      if (dob == null) {
        SnackBarService.showToast(
            title: "Unsuccessful: we need your date of birth for rating purpose.");
        return SignUpResponseModel(success: false,
            message: "Unsuccessful: we need your date of birth for rating purpose.");
      }
      final docRef = _firestore.collection('users').doc(); // Generate a new document reference with an ID
      var preLoad = {
        'id': docRef.id,
        'email': res.user!.email,
        'firstName': res.user!.displayName!.split(' ')?.first ?? '',
        'lastName': res.user!.displayName!.split(' ').length > 1 ? res.user!
            .displayName
            ?.split(' ')
            .last : '',
        'photoURL':res.user!.photoURL,
        'dob': dob,
        'wpDetails': wpDetails ?? {},
        'readStories':[]
      };
      var load = {
        ...preLoad,
        'createdAt': FieldValue.serverTimestamp().toString(),
        'updatedAt': FieldValue.serverTimestamp().toString(),
      };
      await docRef.set(load);

      AppInitializer.maps.put('user',preLoad);
      AppInitializer.bools.put('hasSignedUp',true);
      SnackBarService.showToast(title: "Google sign-up successful");
      print("User added successfully!");
      return SignUpResponseModel(
          success: true, message: "Google sign-up successful");
    } on FirebaseAuthException catch (e) {
      SnackBarService.showToast(
          title: e.message ?? "An error occurred during Google sign-up");
      return SignUpResponseModel(
        success: false,
        message: e.message ?? "An error occurred during Google sign-up",
      );
    } catch (e) {
      SnackBarService.showToast(title: "An unexpected error occurred");
      return SignUpResponseModel(
          success: false, message: "An unexpected error occurred");
    }
  }

  @override
  Future<SignUpResponseModel> checkUserExist({
    required String email,
  }) async {
    try {
      final List<String> signInMethods = await _firebaseAuth
          .fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        return SignUpResponseModel(
            success: true, userExist: true, message: "User exists");
      } else {
        return SignUpResponseModel(
            success: true, userExist: false, message: "User does not exist");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return SignUpResponseModel(
        success: false,
        message: e.message ?? "An error occurred while checking user existence",
      );
    } catch (e) {
      print(e);
      return SignUpResponseModel(
          success: false, message: "An unexpected error occurred");
    }
  }

  @override
  Future<String?> getUserProfile(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://people.googleapis.com/v1/people/me?personFields=birthdays'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final birthdays = data['birthdays'];
        if (birthdays != null && birthdays.isNotEmpty) {
          final birthday = birthdays[0]['date'];
          final year = birthday['year'];
          final month = birthday['month'];
          final day = birthday['day'];

          if (year != null && month != null && day != null) {
            return '$day-$month-$year';
          } else {
            return null;
          }
        } else {
          return null;
        }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}