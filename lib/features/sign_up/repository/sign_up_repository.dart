import 'package:estella/features/sign_up/data/models/sign_up_response_model.dart';

abstract class SignUpRepository{
  Future<SignUpResponseModel> signUpWithPassword({
    required String email,
    required String password,
    required String fullName,
  });
  Future<SignUpResponseModel> signUpWithGoogle();
  Future<SignUpResponseModel> checkUserExist({
    required String email,
  });
  Future<String?> getUserProfile(String accessToken);
}