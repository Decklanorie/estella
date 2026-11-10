import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:estella/core/utils/size_utils.dart';


extension LightTextStyle on TextTheme{
  TextStyle get HeaderTextBoldAuto =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get HeaderTextMediumAuto =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get HeaderTextSmallAuto =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get HeaderTextBold =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 34/24
  );
  TextStyle get HeaderTextMedium =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 34/24
  );
  TextStyle get HeaderTextSmall =>  GoogleFonts.poppins(
      fontSize: 24.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 34/24
  );

  TextStyle get TitleTextAutoBold =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextAutoMedium =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextAutoRegular =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextBold =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 30/20
  );
  TextStyle get TitleTextMedium =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 30/20
  );
  TextStyle get TitleTextRegular =>  GoogleFonts.poppins(
      fontSize: 20.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 30/20
  );

  TextStyle get TitleTextSmallAutoBold =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextAutoSmallMedium =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextAutoSmallRegular =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
  );
  TextStyle get TitleTextSmallBold =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 28/18
  );
  TextStyle get TitleTextSmallMedium =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 28/18
  );
  TextStyle get TitleTextSmallRegular =>  GoogleFonts.poppins(
      fontSize: 18.0.fSize,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      
      height: 28/18
  );



  TextStyle get BodyTextBigBoldAuto =>  GoogleFonts.poppins(
    fontSize: 16.0.fSize,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextBigMediumAuto =>  GoogleFonts.poppins(
    fontSize: 16.0.fSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextBigRegularAuto =>  GoogleFonts.poppins(
    fontSize: 16.0.fSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextBigBold =>  GoogleFonts.poppins(
      fontSize: 16.0.fSize,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      
      height: 26/16
  );
  TextStyle get BodyTextBigMedium =>  GoogleFonts.poppins(
      fontSize: 16.0.fSize,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      
      height: 26/16
  );
  TextStyle get BodyTextBigRegular =>  GoogleFonts.poppins(
      fontSize: 16.0.fSize,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      
      height: 26/16
  );



  TextStyle get BodyTextSmallBoldAuto =>  GoogleFonts.poppins(
    fontSize: 14.0.fSize,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextSmallMediumAuto =>  GoogleFonts.poppins(
    fontSize: 14.0.fSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextSmallRegularAuto =>  GoogleFonts.poppins(
    fontSize: 14.0.fSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextSmallestRegularAuto =>  GoogleFonts.poppins(
    fontSize: 10.0.fSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextSmallMediumAuto12 =>  GoogleFonts.poppins(
    fontSize: 12.0.fSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    
  );
  TextStyle get BodyTextSmallBold =>  GoogleFonts.poppins(
      fontSize: 14.0.fSize,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      
      height: 20/14
  );
  TextStyle get BodyTextSmallMedium =>  GoogleFonts.poppins(
      fontSize: 14.0.fSize,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      
      height: 20/14
  );
  TextStyle get BodyTextSmallRegular =>  GoogleFonts.poppins(
      fontSize: 14.0.fSize,
      fontWeight: FontWeight.w300,
      color: AppColors.textPrimary,
      
      height: 20/14
  );
}

class DarkTextStyle extends TextTheme{
  TextStyle get customTextStyle =>  GoogleFonts.poppins(
    fontSize: 18.0.fSize,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  );
}
