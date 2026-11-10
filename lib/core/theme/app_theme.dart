import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:estella/core/utils/size_utils.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.h),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.universalWhite;
        }),
        side: BorderSide(
          width: .5,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 3,
        space: 3,
        color: AppColors.dividerColor,
      ),
    );

  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
    );
  }
}

ThemeData get theme => AppTheme.lightTheme.brightness == Brightness.dark?AppTheme.darkTheme:AppTheme.lightTheme;