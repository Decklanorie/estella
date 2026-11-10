import 'package:flutter/cupertino.dart';

class ISize{
  static double hh(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double wh(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}