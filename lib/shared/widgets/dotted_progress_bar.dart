

import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';

Widget dottedProgress({required int step}){
  return Container(
    width: double.maxFinite,
    padding: EdgeInsets.symmetric(
        horizontal: 15
    ),
    height: 7,
    color: Color.fromARGB(255, 255, 255, 255),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: step>=1?AppColors.complementary:AppColors.complementaryShade1,
            ), // Use the color code here
            height: 4, // Set the desired height
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: step>=2?AppColors.complementary:AppColors.complementaryShade1),
            height: 4, // Set the desired height
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: step>=3?AppColors.complementary:AppColors.complementaryShade1),
            height: 4, // Set the desired height
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: step>=4?AppColors.complementary:AppColors.complementaryShade1),
            height: 4, // Set the desired height
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: step>=5?AppColors.complementary:AppColors.complementaryShade1),
            height: 4, // Set the desired height
          ),
        ),
      ],
    ),
  );
}