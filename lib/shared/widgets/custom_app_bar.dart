import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_spacing.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/core/utils/size_utils.dart';
import 'package:estella/gen/assets.gen.dart';
import 'package:estella/shared/widgets/custom_image_view.dart';
import 'package:estella/shared/widgets/spacing.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.title,
    this.centerTitle,
    this.actions,
    this.onBack,
    this.flexibleSpace,
    this.backgroundColor,
    this.hideBackButton = false,
  }) : super(
    key: key,
  );

  final double? height;
  final String? title;
  final bool? centerTitle;
  final bool hideBackButton;
  final List<Widget>? actions;
  final Function()? onBack;
  final Widget? flexibleSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor??AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(8),
          ),
        ),
        title: title==null?null:Text(title!,
          style: theme.textTheme.BodyTextSmallMediumAuto
        ),
        elevation: 0,
        titleSpacing:0,
        leading: hideBackButton?SizedBox.shrink():GestureDetector(
            onTap: onBack??(){
              Navigator.pop(context);
            },
            child: Container(
                width: 40,
                height: 40,
                color: Colors.transparent,
                child: Center(
                  child: CustomImageView(
                    imagePath: Assets.images.arrowLeft.path,
                    width: 18,
                    height: 18,
                    radius: BorderRadius.zero,
                    fit: BoxFit.fitWidth,
                  ),
                )
            )
        ),
        centerTitle: centerTitle ?? false,
        actions: [...(actions??[]),addHorizontalSpacing(20)],
        flexibleSpace: flexibleSpace,
        expandedHeight:height
    );
  }


  @override
  Size get preferredSize => Size(
    SizeUtils.width,
    height ?? 32.v,
  );

}
