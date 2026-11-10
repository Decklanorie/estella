import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_spacing.dart';
import 'package:estella/core/utils/size_utils.dart';
import 'package:estella/shared/widgets/spacing.dart';

class SnackBarService {
 static showSnackBar({
    @required String? message,
    Function()? onActionClicked,
    Duration? duration,
    String? actionLabel,
   String? icon,
   bool? error,
   bool? comingSoon,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        dismissDirection: DismissDirection.startToEnd,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          padding: EdgeInsets.all(08),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: error == true? AppColors.red: AppColors.primary,
              borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              addHorizontalSpacing(AppSpacing.small),
              Text(
                message ?? "",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.fSize
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Icon(
                comingSoon == true? Icons.more_horiz: error==true?Icons.warning_amber:Icons.check,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showToast({
    required String? title
}){
    Fluttertoast.showToast(
      msg: title??'',
      toastLength: Toast.LENGTH_SHORT, // LENGTH_LONG also available
      gravity: ToastGravity.TOP, // Position (BOTTOM, CENTER, TOP)
      textColor: Colors.white,
      backgroundColor: Colors.black,
      fontSize: 12.0.fSize,
    );
  }
}
