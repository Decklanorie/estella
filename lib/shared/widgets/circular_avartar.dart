import 'package:flutter/cupertino.dart';

class CircularAvatar extends StatefulWidget {
   CircularAvatar({super.key, required this.size, this.child,
     this.color, this.padding, this.image});
   double size;
   Widget? child;
   Color? color;
   EdgeInsets? padding;
   String? image;
  @override
  State<CircularAvatar> createState() => _CircularAvatarState();
}

class _CircularAvatarState extends State<CircularAvatar> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: widget.size,
      width: widget.size,
      padding: widget.padding,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(10000),
        color: widget.color,
        image: widget.image!=null? DecorationImage(
            image: AssetImage(widget.image!),
            fit: BoxFit.cover
        ):null,
      ),
        child:widget.child
    );
  }
}
