import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitializer {
  static late Box<bool> bools;
  static late Box<Map> maps;
  static late Box<String> strings;
  static late Box<List> lists;
  static late Box<int> ints;
  static late BuildContext context;
  static late WidgetRef ref;

  Future initializeHiveBoxes() async{
    await Hive.initFlutter();
    bools = await Hive.openBox<bool>("bools");
    maps = await Hive.openBox<Map>("maps"); // Properly typed
    strings = await Hive.openBox<String>("strings");
    lists = await Hive.openBox<List<dynamic>>("lists");       // Properly typed
    ints = await Hive.openBox<int>("ints");
  }

  Future<void> initializeFirebaseAppCheck() async {
    await FirebaseAppCheck.instance.activate(
        appleProvider: AppleProvider.debug,
        androidProvider: AndroidProvider.debug
    );
  }

  void initializeFoundation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> performStartupLogic(BuildContext context, WidgetRef ref) async{
    AppInitializer.context = context;
    AppInitializer.ref = ref;
    await Future.delayed(const Duration(seconds: 1)); // Simulates Timer

    // Check environment
    if (strings.get('environment') != dotenv.env['ENVIRONMENT']) {
      strings.put('environment', dotenv.env['ENVIRONMENT'] ?? '');
      // todo: await logout(
      //   context,
      //   strings: strings,
      //   boolsBox: bools,
      //   mapsBox: maps,
      //   listsBox: lists,
      //   intsBox: ints,
      // );
    } else {
      // Check login state
      bool hasSetReadTime = bools.get('hasSetReadTime', defaultValue: false)!;
      bool isSignedIn = bools.get('isSignedIn', defaultValue: false)!;
      if (isSignedIn||hasSetReadTime) {

      } else {
        context.push(AppRoutes.phoneEntry);
      }
    }
  }
}
