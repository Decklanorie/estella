import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:estella/shared/repository/wp_repository.dart';
import 'package:estella/shared/data/models/wp_response_model.dart';


class WPRepositoryImpl implements WPRepository {
  final String baseUrl = 'https://storytime.ng';

  @override
  Future<WPResponseModel> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/categories'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return WPResponseModel(success: true, categories: data);
      } else {
        return WPResponseModel(
            success: false, message: 'Failed to fetch categories');
      }
    } catch (e) {
      print(e);
      return WPResponseModel(success: false, message: e.toString());
    }
  }

  @override
  Future<WPResponseModel> getPostById(String postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts/$postId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WPResponseModel(success: true, post: data);
      } else {
        return WPResponseModel(
            success: false, message: 'Failed to fetch post with ID: $postId');
      }
    } catch (e) {
      return WPResponseModel(success: false, message: e.toString());
    }
  }
}
