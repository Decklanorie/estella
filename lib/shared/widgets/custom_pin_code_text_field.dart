import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/utils/size.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeTextField extends StatefulWidget {
  CustomPinCodeTextField({
    Key? key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.color,
    this.obscureText,
    this.applyPinLoginTheme,
    this.length,
  }) : super(
    key: key,
  );

  final Color? color;
  final bool? obscureText;
  final bool? applyPinLoginTheme;
  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;
  final int? length;

  Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  _CustomPinCodeTextFieldState createState() =>
      _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState
    extends State<CustomPinCodeTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ISize.wh(context),
      child: widget.alignment != null
          ? Align(
        alignment: widget.alignment ?? Alignment.center,
        child: pinCodeTextFieldWidget,
      )
          : pinCodeTextFieldWidget,
    );
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
    appContext: context,
    controller: widget.controller,
    length: widget.length??4,
    obscureText:widget.obscureText??false,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    textStyle: widget.textStyle,
    hintStyle: widget.hintStyle,

    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.all(Radius.circular(widget.applyPinLoginTheme==true?10:10)),
      inactiveColor:  widget.color??AppColors.primary,
      activeColor:  widget.color??AppColors.primary,
      fieldWidth:ISize.wh(context)*.15,
      fieldHeight:60,
      selectedColor: widget.color??AppColors.primary,
      activeFillColor:  widget.color??AppColors.primary,
      selectedFillColor:  widget.color??AppColors.primary,
      inactiveFillColor:  widget.color??AppColors.primary,
      fieldOuterPadding: EdgeInsets.all(4),
      borderWidth: .1,
      activeBorderWidth: .1,
      inactiveBorderWidth: .8,
    ),
    onChanged: (value) => widget.onChanged(value),
    validator: widget.validator,
  );
}
