// import 'package:flutter/material.dart';
// import 'package:estella/core/theme/app_colors.dart';
// import 'package:estella/core/theme/app_text_styles.dart';
// import 'package:estella/core/utils/size_utils.dart';
// import 'package:estella/core/navigation/routes.dart';
// import 'package:estella/shared/widgets/custom_elevated_button.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../core/theme/app_spacing.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../../../shared/widgets/spacing.dart';
//
// Widget buildGetStartedButton(BuildContext context) {
//   return Container(
//     height: 130.v,
//     child: Column(
//       children: [
//         CustomElevatedButton(
//           onPressed: (() {
//             context.push(AppRoutes.sign_up_form);
//           }),
//           text: "Let’s Get Started",
//           margin: EdgeInsets.only(
//             left: 36.h,
//             right: 27.h,
//           ),
//           buttonTextStyle: Theme.of(context).textTheme.BodyTextSmallMediumAuto.copyWith(
//             color: AppColors.universalWhite
//           ),
//         ),
//         addVerticalSpacing(AppSpacing.small),
//         Center(
//           child: TextButton(
//             child: Text.rich(TextSpan(text: 'Already have an account? ',
//                 style: theme.textTheme.BodyTextSmallRegular.copyWith(fontSize: 12.fSize, fontWeight: FontWeight.w500),
//                 children: [
//                   TextSpan(text: 'Sign in',style: theme.textTheme.BodyTextSmallRegular.copyWith(
//                       color: AppColors.primary,
//                       fontSize: 12.fSize, decoration: TextDecoration.underline, fontWeight: FontWeight.w500))
//                 ])),
//             onPressed: (){
//               context.push(AppRoutes.sign_in_form);
//             },
//           ),
//         )
//       ],
//     ),
//   );
// }