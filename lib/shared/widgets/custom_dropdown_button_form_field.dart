import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/features/intro/presentation/widgets/build_get_started_button.dart';
import 'package:estella/core/utils/size_utils.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  CustomDropdownButtonFormField({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.decoration,
    this.style,
    this.value,
    required this.items,
    this.borderColor,
  }) : super(
    key: key,
  );

  final Function(String? val)? onChanged;

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final FocusNode? focusNode;

  final bool autofocus;

  final TextStyle? textStyle;

  final TextStyle? style;

  final String? hintText;

  final String? value;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final List<DropdownMenuItem<String>> items;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final Color? borderColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: DropdownButtonFormFieldWidget(context),
    )
        : DropdownButtonFormFieldWidget(context);
  }

  Widget DropdownButtonFormFieldWidget(BuildContext context) => SizedBox(
    width: width ?? double.maxFinite,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor??AppColors.grey1,width: 1),
      ),
      child:DropdownButtonFormField(
        value:value,
        focusNode: focusNode,
        autofocus: autofocus,
        style: style,
        items:items,
        decoration: InputDecoration(
          filled: false,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color:AppColors.primary
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16
          ),
          hintStyle: hintStyle??theme.textTheme.BodyTextSmallRegularAuto.copyWith(color: AppColors.grey1, fontSize: 12.fSize),
        ),
        onChanged: onChanged,
      ),
    ),
  );

}
