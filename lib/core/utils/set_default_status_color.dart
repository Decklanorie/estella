import 'dart:io';
import 'package:flutter/services.dart';
import 'package:estella/core/theme/app_colors.dart';

void setDefaultStatusColor(){
    if(Platform.isAndroid){
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                systemNavigationBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
            )
        );
    }
}
void removeStatusColor(){
    if(Platform.isAndroid){
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                systemNavigationBarColor: AppColors.transparent,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.light,
            )
        );
    }
}
void storyStatusColor(){
    if(Platform.isAndroid){
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                systemNavigationBarColor: AppColors.complementaryShade1,
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.light,
            )
        );
    }
}