import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/core/utils/size_utils.dart';
import 'core/navigation/app_go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:estella/firebase_options.dart';
import 'package:estella/wpqu_users.dart';
import 'package:estella/core/services/app_initializer.dart';

AppInitializer appInitializer = AppInitializer();

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await appInitializer.initializeHiveBoxes();
  await appInitializer.initializeFirebaseAppCheck();
  appInitializer.initializeFoundation();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.remove();

  runApp(
      ProviderScope(
          child:MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
          );
        });
  }
}

Future<void> setWpData()async{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final batch = _firestore.batch();

  try {
    for (var data in wpDetails) {
      // Create a new document for each user
      final wpDetailsRef = _firestore.collection('wpDetails').doc();
      batch.set(wpDetailsRef, data);
    }

    // Commit the batch
    await batch.commit();
    print("Bulk users added successfully!");
  } catch (e) {
    print("Error adding bulk users: $e");
  }
}