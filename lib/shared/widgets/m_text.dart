import 'package:flutter/material.dart';

class SText extends StatefulWidget {
   SText({super.key, this.text, this.style, this.children,
   this.maxLines, this.overflow});
  String? text;
  List<InlineSpan>? children;
  TextStyle? style;
  int? maxLines;
  TextOverflow? overflow;

  @override
  State<SText> createState() => _STextState();
}

class _STextState extends State<SText> {
  @override
  Widget build(BuildContext context) {
    return  Text.rich(TextSpan(
      text: widget.text,
      style: widget.style,
      children: widget.children
    ), maxLines: widget.maxLines,
    overflow: widget.overflow);
  }
}
