import 'package:flutter/cupertino.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/gen/assets.gen.dart';

Widget tabButton(String title,{Function()? onTap, required double width, required double height, TextStyle? textStyle, bool noPad = false}){
  return GestureDetector(
    child: Container(
      width: width,
      height: height,
      margin: noPad?EdgeInsets.symmetric(horizontal: 3):EdgeInsets.only(top: 10,left: 2,right: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4)
      ),
      child: Center(
        child: Text(title, style: textStyle??theme.textTheme.BodyTextSmallRegularAuto.copyWith(color: AppColors.universalWhite, fontSize: 10),),
      ),
    ),
    onTap: onTap,
  );
}