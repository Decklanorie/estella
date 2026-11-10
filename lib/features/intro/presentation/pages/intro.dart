// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:estella/core/theme/app_spacing.dart';
// import 'package:estella/core/theme/app_text_styles.dart';
// import 'package:estella/core/utils/size.dart';
// import 'package:estella/features/intro/presentation/widgets/build_get_started_button.dart';
// import 'package:estella/gen/assets.gen.dart';
// import 'package:estella/shared/widgets/spacing.dart';
// import 'package:flutter/services.dart';
//
// import '../../../../core/theme/app_colors.dart';
//
// class Intro extends StatefulWidget {
//   const Intro({Key? key}) : super(key: key);
//
//   @override
//   State<Intro> createState() => _IntroState();
// }
//
// class _IntroState extends State<Intro> {
//   int index = 0;
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     var hh = ISize.hh(context);
//     var wh = ISize.wh(context);
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarColor: AppColors.transparent, // Status bar background color
//           statusBarIconBrightness: Brightness.light, // Status bar icon brightness
//           systemNavigationBarColor:
//           AppColors.background, // Navigation bar background color
//           systemNavigationBarIconBrightness:
//           Brightness.dark, // Navigation bar icon brightness
//         ),
//         child:Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Container(
//         height: ISize.hh(context),
//         width: ISize.wh(context),
//         child:ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             SizedBox(
//               height: wh +50,
//               width: wh,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
//                 child: Image.asset(
//                   Assets.images.intro.path,
//                   height: hh*.5,
//                   width: wh,
//                   fit: BoxFit.fitWidth,
//                 ),
//               )
//             ),
//             addVerticalSpacing( AppSpacing.large,),
//
//             Center(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 width: ISize.wh(context),
//                 child: Text("Find, book and wash your\nCar Easily. ",
//                   textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.HeaderTextBoldAuto.copyWith(
//                       fontWeight: FontWeight.bold
//                     )
//                 ),
//               ),
//             ),
//             addVerticalSpacing( AppSpacing.mediumLarge),
//             Center(
//               child: Container(
//                 width:250,
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                   child: Text("Get your Car washed at where, time and place ",
//                     textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.BodyTextSmallRegular.copyWith(
//                           fontWeight: FontWeight.w500
//                       )
//                   ),
//               ),
//             ),
//             addVerticalSpacing( AppSpacing.extraLarge),
//
//             buildGetStartedButton(context)
//           ],
//         ),
//       ),
//     )
//     );
//   }
//
//
//
// }
