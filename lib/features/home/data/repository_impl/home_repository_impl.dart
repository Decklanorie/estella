import 'package:estella/features/home/repository/home_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:estella/core/services/app_initializer.dart';
import 'package:estella/shared/helpers/user_state.dart';

class HomeRepositoryImpl implements HomeRepository {
  final String baseUrl = 'https://storytime.ng';

  Future getStories({required int page, String order = 'asc'})async{
    int perPage = 5; // Number of posts per page
    // String order = 'asc'; // Sorting order: 'asc' or 'desc'
    String orderBy = 'date'; // Field to order by: 'date', 'title', etc.
    // List readStories = AppInitializer.ref.read(userStateProvider).readStories;
    // String excludeIds = readStories.isEmpty?'':readStories.join(',');

    // try {
    //   final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=$perPage&order=$order&orderby=$orderBy&excludeIds=$excludeIds'));
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     return data;
    //   } else {
    //     return [];
    //   }
    // } catch (e) {
    //   print(e);
    //   return [];
    // }
  }

  @override
  Future mostViewedStories({required int page, String order = 'asc'})async{
    // int perPage = 5; // Number of posts per page
    // List readStories = AppInitializer.ref.read(userStateProvider).readStories;
    // String excludeIds = readStories.isEmpty?'':readStories.join(',');
    //
    // try {
    //   final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?page=$page&per_page=$perPage&orderby=meta_value&meta_key=post_views&order=$order'));
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     return data;
    //   } else {
    //     return [];
    //   }
    // } catch (e) {
    //   print(e);
    //   return [];
    // }
  }

  @override
  Future getStoriesByCategory({required int page, required String catId})async{
    // int perPage = 5; // Number of posts per page
    // String order = 'asc'; // Sorting order: 'asc' or 'desc'
    // String orderBy = 'date'; // Field to order by: 'date', 'title', etc.
    // List readStories = AppInitializer.ref.read(userStateProvider).readStories;
    // String excludeIds = readStories.isEmpty?'':readStories.join(',');
    //
    // if(catId==null){
    //   return [];
    // }
    // try {
    //   final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?categories=$catId&page=$page&per_page=$perPage&order=$order&orderby=$orderBy&excludeIds=$excludeIds'));
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     return data;
    //   } else {
    //     return [];
    //   }
    // } catch (e) {
    //   print(e);
    //   return [];
    // }
  }

  @override
  Future getStoryDetails({required String storyId})async{
    try {
      final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts/$storyId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future getStoriesByAuthor({required String authorId}) async {
    if(authorId==null){return [];}
    int page = 1; // Pagination: page number
    int perPage = 5; // Number of posts per page
    String? order = 'desc'; // Sorting order: 'asc' or 'desc'
    String? orderBy = 'date'; // Field to order by: 'date', 'title', etc.
    try {
      final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?author=$authorId&page=$page&per_page=$perPage&order=$order&orderby=$orderBy'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future getImagePath({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['source_url'];
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }


}