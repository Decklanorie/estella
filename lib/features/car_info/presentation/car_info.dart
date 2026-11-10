// import 'package:estella/shared/widgets/custom_image_view.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:estella/core/theme/app_colors.dart';
// import 'package:estella/core/theme/app_spacing.dart';
// import 'package:estella/core/theme/app_text_styles.dart';
// import 'package:estella/core/theme/app_theme.dart';
// import 'package:estella/core/utils/size.dart';
// import 'package:estella/gen/assets.gen.dart';
// import 'package:estella/core/navigation/routes.dart';
// import 'package:estella/shared/widgets/custom_elevated_button.dart';
// import 'package:estella/shared/widgets/custom_text_form_field.dart';
// import 'package:estella/core/utils/size_utils.dart';
// import 'package:estella/shared/widgets/label.dart';
// import 'package:estella/shared/widgets/spacing.dart';
//
// class CarInfo extends StatefulWidget {
//   const CarInfo({Key? key}) : super(key: key);
//
//   @override
//   _CarInfoState createState() => _CarInfoState();
// }
//
// class _CarInfoState extends State<CarInfo> {
//   TextEditingController _infoController = TextEditingController();
//   TextEditingController _colorController = TextEditingController();
//   TextEditingController _plateController = TextEditingController();
//   String type = 'saloon';
//
//   final _formKey = GlobalKey<FormState>();
//   bool checkboxValue = false;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double w = ISize.wh(context);
//     double h = ISize.hh(context);
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarColor: AppColors.transparent,
//           // Status bar background color
//           statusBarIconBrightness: Brightness.dark,
//           // Status bar icon brightness
//           systemNavigationBarColor: AppColors.background,
//           // Navigation bar background color
//           systemNavigationBarIconBrightness:
//               Brightness.dark, // Navigation bar icon brightness
//         ),
//         child: Scaffold(
//           appBar: AppBar(
//             leading: BackButton(),
//             backgroundColor: AppColors.universalWhite,
//             title: Text(
//               'Car Information',
//               style: theme.textTheme.BodyTextBigMedium.copyWith(fontSize: 16),
//             ),
//           ),
//           body: SafeArea(
//               child: Container(
//             width: w,
//             height: h,
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: ListView(
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       addVerticalSpacing(
//                         AppSpacing.medium,
//                       ),
//                       SizedBox(
//                         child: Text(
//                           'Enter your car details so we can recognize it instantly.',
//                           style:
//                               theme.textTheme.BodyTextSmallRegular.copyWith(),
//                       )),
//                       addVerticalSpacing(
//                         AppSpacing.large,
//                       ),
//                       label('Location info'),
//                       Container(
//                         height: 120,
//                         width: ISize.wh(context),
//                         child: ListView(
//                           padding: EdgeInsets.zero,
//                           scrollDirection: Axis.horizontal,
//                           children: [
//                             GestureDetector(
//                               child: Container(
//                                   margin: EdgeInsets.only(right: 10),
//                                   height: 120,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                         color: type == 'saloon'
//                                             ? AppColors.primary
//                                             : Colors.grey.withOpacity(.3),
//                                         width: 2),
//                                   ),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: CustomImageView(
//                                         imagePath: Assets.images.saloon.path,
//                                       ),
//                                     ),
//                                   )),
//                               onTap: () {
//                                 setState(() {
//                                   type = 'saloon';
//                                 });
//                               },
//                             ),
//
//                             GestureDetector(
//                               child: Container(
//                                   margin: EdgeInsets.only(right: 10),
//                                   height: 120,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                         color: type == 'suv'
//                                             ? AppColors.primary
//                                             : Colors.grey.withOpacity(.3),
//                                         width: 2),
//                                   ),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: CustomImageView(
//                                         imagePath: Assets.images.suv.path,
//                                       ),
//                                     ),
//                                   )),
//                               onTap: () {
//                                 setState(() {
//                                   type = 'suv';
//                                 });
//                               },
//                             ),
//                             GestureDetector(
//                               child: Container(
//                                   margin: EdgeInsets.only(right: 10),
//                                   height: 120,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                         color: type == 'pickup'
//                                             ? AppColors.primary
//                                             : Colors.grey.withOpacity(.3),
//                                         width: 2),
//                                   ),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: CustomImageView(
//                                         imagePath: Assets.images.pickup.path,
//                                       ),
//                                     ),
//                                   )),
//                               onTap: () {
//                                 setState(() {
//                                   type = 'pickup';
//                                 });
//                               },
//                             ),
//                             GestureDetector(
//                               child: Container(
//                                   margin: EdgeInsets.only(right: 10),
//                                   height: 120,
//                                   width: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(15),
//                                     border: Border.all(
//                                         color: type == 'van'
//                                             ? AppColors.primary
//                                             : Colors.grey.withOpacity(.3),
//                                         width: 2),
//                                   ),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: CustomImageView(
//                                         imagePath: Assets.images.van.path,
//                                       ),
//                                     ),
//                                   )),
//                               onTap: () {
//                                 setState(() {
//                                   type = 'van';
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       addVerticalSpacing(
//                         AppSpacing.inputVerticalSpacing,
//                       ),
//                       label('Location info'),
//                       CustomTextFormField(
//                         controller: _infoController,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         minLines: 3,
//                         maxLines: 5,
//                         onChanged: (val) {
//                           setState(() {});
//                         },
//                         style: TextStyle(
//                             color: const Color.fromARGB(255, 49, 49, 49)),
//                         decoration: InputDecoration(
//                           hintText:
//                               "Example: Its a black toyota camry at the car park",
//                           hintStyle: TextStyle(
//                               fontSize: 14.fSize,
//                               color: Color.fromARGB(255, 176, 176, 176)),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 16),
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: AppColors.grey1),
//                           ),
//                         ),
//                       ),
//                       addVerticalSpacing(
//                         AppSpacing.inputVerticalSpacing,
//                       ),
//                       label('Car color'),
//                       CustomTextFormField(
//                         controller: _colorController,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         onChanged: (val) {
//                           setState(() {});
//                         },
//                         style: TextStyle(
//                             color: const Color.fromARGB(255, 49, 49, 49)),
//                         decoration: InputDecoration(
//                           hintText: "Car color, eg black",
//                           hintStyle: TextStyle(
//                               fontSize: 14.fSize,
//                               color: Color.fromARGB(255, 176, 176, 176)),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 16),
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: AppColors.grey1),
//                           ),
//                         ),
//                       ),
//                       addVerticalSpacing(
//                         AppSpacing.inputVerticalSpacing,
//                       ),
//                       label('Plate number'),
//                       CustomTextFormField(
//                         controller: _plateController,
//                         autovalidateMode: AutovalidateMode.always,
//                         onChanged: (val) {
//                           setState(() {});
//                         },
//                         style: TextStyle(
//                             color: const Color.fromARGB(255, 49, 49, 49)),
//                         decoration: InputDecoration(
//                           hintText: "Plate number",
//                           hintStyle: TextStyle(
//                               fontSize: 14.fSize,
//                               color: Color.fromARGB(255, 176, 176, 176)),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 16),
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: AppColors.grey1),
//                           ),
//                         ),
//                       ),
//                       addVerticalSpacing(
//                         AppSpacing.mediumLarge,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           )),
//           bottomNavigationBar: Container(
//             height: 50,
//             margin: EdgeInsets.symmetric(horizontal: 15),
//             width: w,
//             child: CustomElevatedButton(
//               onPressed: () => context.push(AppRoutes.payment),
//               text: "Continue to payment",
//               buttonTextStyle: Theme.of(context)
//                   .textTheme
//                   .BodyTextSmallMediumAuto
//                   .copyWith(color: AppColors.universalWhite),
//             ),
//           ),
//         ));
//   }
// }
