import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/core/utils/size_utils.dart';


Widget label(text, {style}){
  return Padding(
    padding: EdgeInsets.only(
      bottom: 8.v
    ),
    child: Text(text,
      style: style??theme.textTheme.BodyTextSmallMediumAuto
    ),
  );
}