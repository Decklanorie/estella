import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/features/intro/presentation/widgets/build_get_started_button.dart';
import 'package:estella/core/utils/size_utils.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.autovalidateMode,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.decoration,
    this.maxLength,
    this.style,
    this.readOnly = false,
  }) : super(
    key: key,
  );

  final Function(String val)? onChanged;

  final Alignment? alignment;

  final double? width;

  final int? maxLength;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool autofocus;

  final TextStyle? textStyle;

  final TextStyle? style;

  final bool? obscureText;
  final AutovalidateMode? autovalidateMode;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final int? maxLines;

  final int? minLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final bool readOnly;

  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: textFormFieldWidget(context),
    )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
    width: width ?? double.maxFinite,
    child: Stack(
        children: [
         Positioned.fill(child:  Container(
           width: width ?? double.maxFinite,
           decoration: BoxDecoration(
             color: AppColors.grey1.withOpacity(.1),
             borderRadius: BorderRadius.circular(12),
           ),
         )),
          TextFormField(
            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: controller,
            autovalidateMode:autovalidateMode,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            readOnly:readOnly,
            focusNode: focusNode,
            autofocus: autofocus,
            maxLength:maxLength,
            style: style,
            validator: validator,
            obscureText: obscureText!,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            inputFormatters:inputFormatters,
            maxLines: maxLines ?? 1,
            minLines: minLines,
            decoration: decoration?.copyWith(
              filled: false,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16
              ),
              hintStyle: theme.textTheme.BodyTextSmallRegularAuto.copyWith(color: AppColors.grey1, fontSize: 12.fSize),
            ),
            onChanged: onChanged,
          ),
        ],
      )
  );

}
