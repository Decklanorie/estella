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
// import 'package:estella/shared/widgets/custom_dropdown_button_form_field.dart';
// import 'package:estella/shared/widgets/custom_elevated_button.dart';
// import 'package:estella/shared/widgets/custom_text_form_field.dart';
// import 'package:estella/core/utils/size_utils.dart';
// import 'package:estella/shared/widgets/label.dart';
// import 'package:estella/shared/widgets/spacing.dart';
// import 'package:estella/features/sign_up/data/repository_impl/sign_up_repository_impl.dart';
// import 'package:estella/features/sign_up/data/models/sign_up_response_model.dart';
// import 'package:estella/shared/widgets/snackbar_service.dart';
//
//
// class SignUpForm extends StatefulWidget {
//   const SignUpForm({Key? key}) : super(key: key);
//
//   @override
//   _SignUpFormState createState() =>
//       _SignUpFormState();
// }
//
// class _SignUpFormState
//     extends State<SignUpForm> {
//   TextEditingController _fullNameController = TextEditingController();
//
//   TextEditingController _emailAddressController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
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
//           statusBarColor: AppColors.transparent, // Status bar background color
//           statusBarIconBrightness: Brightness.dark, // Status bar icon brightness
//           systemNavigationBarColor:
//           AppColors.background, // Navigation bar background color
//           systemNavigationBarIconBrightness:
//           Brightness.dark, // Navigation bar icon brightness
//         ),
//         child:Scaffold(
//         body: SafeArea(
//             child: Container(
//               width: w,
//               height: h,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: ListView(
//                 children: [
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//
//                         addVerticalSpacing( AppSpacing.medium,),
//                         Center(
//                           child: Text('Create Account', style: theme.textTheme.BodyTextBigMedium,),
//                         ), addVerticalSpacing( AppSpacing.medium,),
//                         Center(
//                           child: SizedBox(
//                             width: 250,
//                             child: Text('Fill in your information or register with your social media', style: theme.textTheme.BodyTextSmallRegular.copyWith(
//                             ),textAlign: TextAlign.center,
//                             ),
//                           )
//                         ),
//                         addVerticalSpacing(AppSpacing.large,),
//                         label('Full Name'),
//                         CustomTextFormField(
//                           controller: _fullNameController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           onChanged:(val){
//                             setState(() {});
//                           },
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Field can not be empty';
//                             }
//                             return null;
//                           },
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 49, 49, 49)
//                           ),
//                           decoration: InputDecoration(
//                             hintText: "Enter your name",
//                             hintStyle: TextStyle(
//                                 fontSize: 14.fSize,
//                                 color:
//                                 Color.fromARGB(255, 176, 176, 176)),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 16),
//                             border: InputBorder.none,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                   color: AppColors.grey1
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         addVerticalSpacing(AppSpacing.inputVerticalSpacing,),
//                         label('Email Address'),
//                         CustomTextFormField(
//                           controller: _emailAddressController,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           onChanged:(val){
//                             setState(() {});
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Email is required.';
//                             }
//                             // Regex for email validation
//                             else if (!RegExp(
//                                 r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
//                                 .hasMatch(value)) {
//                               return 'Enter a valid email.';
//                             }
//                             return null;
//                           },
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 49, 49, 49)
//                           ),
//                           decoration: InputDecoration(
//                             hintText: "Email Address",
//                             hintStyle: TextStyle(
//                                 fontSize: 14.fSize,
//                                 color:
//                                 Color.fromARGB(255, 176, 176, 176)),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 16),
//                             border: InputBorder.none,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                   color: AppColors.grey1
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         addVerticalSpacing(AppSpacing.inputVerticalSpacing,),
//                         label('Password'),
//                         CustomTextFormField(
//                           controller: _passwordController,
//                           autovalidateMode: AutovalidateMode.always,
//                           onChanged:(val){
//                             setState(() {});
//                           },
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Field can not be empty';
//                             }else if (value.length <6) {
//                               return 'Field must be 6 digit or more';
//                             }
//                             return null;
//                           },
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 49, 49, 49)
//                           ),
//                           decoration: InputDecoration(
//                             hintText: "Enter password",
//                             hintStyle: TextStyle(
//                                 fontSize: 14.fSize,
//                                 color:
//                                 Color.fromARGB(255, 176, 176, 176)),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 16),
//                             border: InputBorder.none,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(
//                                   color: AppColors.grey1
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         addVerticalSpacing(AppSpacing.inputVerticalSpacing,),
//
//                         Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 0),
//                             child: Row(
//                               children: [
//                                 Checkbox(
//                                   checkColor:AppColors.universalWhite,
//                                   activeColor: AppColors.primary,
//                                   value: checkboxValue,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       checkboxValue = value!;
//                                     });
//                                   },
//                                 ),
//
//                                 Container(
//                                   width: ISize.wh(context)*.7,
//                                   child:  Text.rich(
//                                     TextSpan(
//                                         text: "Agree with Terms and Condition",
//                                         style: theme.textTheme.BodyTextSmallRegular.copyWith(fontSize: 12.fSize, fontWeight: FontWeight.w500),
//                                     ),
//                                     softWrap: true,
//                                   ),
//                                 )
//                               ],
//                             )
//                         ),
//
//
//                         addVerticalSpacing(AppSpacing.mediumLarge,),
//
//
//                         Container(
//                           height: 50,
//                           width: w,
//                           child:  CustomElevatedButton(
//                             isLoading: isLoading,
//                             isDisabled: isLoading||(_formKey.currentState?.validate()??false)==false,
//                             onPressed: () async{
//                               if (!checkboxValue) {
//                                 SnackBarService.showSnackBar(message: 'You must agree to the terms and conditions.', context: context);
//                                 return;
//                               }
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               SignUpResponseModel res = await  SignUpRepositoryImpl().signUpWithPassword(
//                                   email: _emailAddressController.text.trim(),
//                                   password: _passwordController.text.trim(),
//                                   fullName: _fullNameController.text.trim(),
//                               );
//                               if(res.success==true){
//                                 context.push(AppRoutes.home);
//                               }
//                               try{
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                               }catch(e){}
//                             },
//                             text: "Sign Up",
//                             buttonTextStyle: Theme.of(context).textTheme.BodyTextSmallMediumAuto.copyWith(
//                                 color: AppColors.universalWhite
//                             ),
//                           ),
//                         ),
//
//                         addVerticalSpacing(AppSpacing.small,),
//                         Center(
//                           child: TextButton(
//                             child: Text.rich(TextSpan(text: 'Already have an account? ',
//                                 style: theme.textTheme.BodyTextSmallRegular.copyWith(fontSize: 12.fSize, fontWeight: FontWeight.w500),
//                                 children: [
//                                   TextSpan(text: 'Sign in',style: theme.textTheme.BodyTextSmallRegular.copyWith(
//                                       color: AppColors.primary,
//                                       fontSize: 12.fSize, decoration: TextDecoration.underline, fontWeight: FontWeight.w500))
//                                 ])),
//                             onPressed: (){
//                               context.push(AppRoutes.sign_in_form);
//                             },
//                           ),
//                         )
//
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//         ))
//     );
//   }
//
// }
