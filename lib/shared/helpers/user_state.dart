import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estella/shared/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estella/main.dart';
import 'package:estella/core/services/app_initializer.dart';


final userStateProvider= AutoDisposeStateNotifierProvider<UserNotifier, UserModel>((ref)=>UserNotifier());

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel.fromJson(AppInitializer.maps.get('user',defaultValue: {})! as Map<String, dynamic>));

  @override
  Future<UserModel?> build() async {
     return (await getUser());
  }

  Future<UserModel> getUser()async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserModel user = UserModel.fromJson(AppInitializer.maps.get('user',defaultValue: {})! as Map<String, dynamic>);
    try {
      String id = user.id!;
      var res = await _firestore.collection('users').doc(id).get();
      user = UserModel.fromJson(res.data()??{});
      state = user;
    }catch(e){
      state = user;
    }
    return user;
  }

}