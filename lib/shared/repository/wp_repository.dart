import 'package:estella/shared/data/models/wp_response_model.dart';

abstract class WPRepository {
  Future<WPResponseModel> getCategories();
  Future<WPResponseModel> getPostById(String postId);

}