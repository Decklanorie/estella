import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/utils/size_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import 'base_button.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
    bool? isLoading,
    this.backgroundColor,
    this.radius,
    this.shadowColor,
    this.border
  }) : super(
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      isDisabled: isDisabled,
      buttonTextStyle: buttonTextStyle,
      height: height,
      width: width,
      alignment: alignment,
      margin: margin,
      isLoading:isLoading
  );

  BoxDecoration? decoration;
  Color? backgroundColor;
  double? radius;
  Color? shadowColor;
  BoxBorder? border;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildElevatedButtonWidget,
    )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: this.height ?? 50.v,
    width: this.width ?? double.maxFinite,
    margin: margin,
    decoration: decoration??BoxDecoration(
        borderRadius: BorderRadius.circular(radius??15.h),
    border:border
    ),
    child: ElevatedButton(
      style: buttonStyle??ElevatedButton.styleFrom(
        backgroundColor: backgroundColor??AppColors.primary,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius??15.h),
        ),
      ),
      onPressed: isDisabled ?? false ? null : onPressed ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftIcon ?? const SizedBox.shrink(),
          isLoading==true? Container(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),):
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w500,
              color: buttonTextStyle?.color
            ),
          ),
          rightIcon ?? const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
