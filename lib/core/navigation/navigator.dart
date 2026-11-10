import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavigatorKeys {
  AppNavigatorKeys._privateContructor();

  static AppNavigatorKeys instance = AppNavigatorKeys._privateContructor();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<ScaffoldMessengerState> scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
}

Future<T?> navigateToRoute<T>(BuildContext context, dynamic routeClass,
    {bool useMaterial = true}) {
  return Navigator.of(context).push(useMaterial || Platform.isAndroid
      ? MaterialPageRoute(builder: (context) => routeClass)
  // ? _createRoute(context, routeClass)
      : CupertinoPageRoute(builder: (context) => routeClass));
}

navigateToRouteNoTransition(
    BuildContext context,
    dynamic routeClass,
    ) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => routeClass,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

navigateReplaceRouteNoTransition(
    BuildContext context,
    dynamic routeClass,
    ) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => routeClass,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

Future<dynamic> navigateToRouteForResult(
    BuildContext context, dynamic routeClass,
    {bool useMaterial = true}) async {
  return await Navigator.push(
      context,
      useMaterial || Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => routeClass)
      // ? _createRoute(context, routeClass)
          : CupertinoPageRoute(builder: (context) => routeClass));
}


void navigateAndReplaceRoute(BuildContext? context, dynamic routeClass) {
  Navigator.pushReplacement(
      context!,
      Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => routeClass)
          : CupertinoPageRoute(builder: (context) => routeClass));
}

void navigateAndRemoveUntilRoute(BuildContext? context, dynamic routeClass) {
  Navigator.pushAndRemoveUntil(
      context!,
      Platform.isAndroid
          ? MaterialPageRoute(builder: (context) => routeClass)
          : CupertinoPageRoute(builder: (context) => routeClass),
          (route) => false);
}


