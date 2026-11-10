import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';


class BottomNavItem extends StatefulWidget {
   BottomNavItem({super.key, required this.index});
  int index;

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem> {

  void onTap(){

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            shape: BoxShape.circle,
          ),
          child:Stack(
            children: [

            ],
          )
      ),
      onTap: onTap,
    );
  }
}

