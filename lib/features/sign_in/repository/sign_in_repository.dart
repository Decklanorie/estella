import 'package:estella/features/sign_up/data/models/sign_up_response_model.dart';
import 'package:estella/shared/data/models/response_model.dart';

abstract class SignInRepository{
  Future<ResponseModel> signInWithPassword({
    required String email,
    required String password
  });
  Future<ResponseModel> signInWithGoogle();
}