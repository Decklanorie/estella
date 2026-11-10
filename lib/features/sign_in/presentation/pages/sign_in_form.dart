// import 'package:estella/core/utils/extensions.dart';
// import 'package:estella/shared/data/models/user_model.dart';
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
// import 'package:estella/shared/data/models/response_model.dart';
// import 'package:estella/features/sign_in/data/repository_impl/sign_in_repository_impl.dart';
// import 'package:estella/shared/widgets/snackbar_service.dart';
//
// import '../../../../core/services/app_initializer.dart';
//
// class SignInForm extends StatefulWidget {
//   const SignInForm({Key? key}) : super(key: key);
//
//   @override
//   _SignInFormState createState() =>
//       _SignInFormState();
// }
//
// class _SignInFormState
//     extends State<SignInForm> {
//
//   TextEditingController _emailAddressController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     double w = ISize.wh(context);
//     double h = ISize.hh(context);
//     return Scaffold(
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
//                         addVerticalSpacing( AppSpacing.medium,),
//                         Center(
//                           child: Text('Sign In', style: theme.textTheme.BodyTextBigMedium,),
//                         ), addVerticalSpacing( AppSpacing.medium,),
//                         Center(
//                             child: Text('Hi, welcome back you’ve been missed', style: theme.textTheme.BodyTextSmallRegular.copyWith(
//                               ),textAlign: TextAlign.center,
//                             )
//                         ),
//                         addVerticalSpacing(AppSpacing.large,),
//                         addVerticalSpacing( AppSpacing.medium,),
//
//                         label('Email Address'),
//                         CustomTextFormField(
//                           controller: _emailAddressController,
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
//                         addVerticalSpacing(AppSpacing.mediumLarge,),
//
//                         Container(
//                           height: 50,
//                           width: w,
//                           child:  CustomElevatedButton(
//                             text: "Create my account",
//                             isLoading: isLoading,
//                             isDisabled: isLoading||(_formKey.currentState?.validate()??false)==false,
//                             onPressed: () async{
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               ResponseModel res = await  SignInRepositoryImpl().signInWithPassword(
//                                   email: _emailAddressController.text.trim(),
//                                   password: _passwordController.text.trim(),
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
//                             buttonTextStyle: Theme.of(context).textTheme.BodyTextSmallMediumAuto.copyWith(
//                                 color: AppColors.universalWhite
//                             ),
//                           ),
//                         ),
//
//                         addVerticalSpacing(AppSpacing.small,),
//                         Center(
//                           child: TextButton(
//                             child: Text.rich(TextSpan(text: 'Do not have an account? ',
//                                 style: theme.textTheme.BodyTextSmallRegular.copyWith(fontSize: 12.fSize, fontWeight: FontWeight.w300),
//                                 children: [
//                                   TextSpan(text: 'Sign up',style: theme.textTheme.BodyTextSmallRegular.copyWith(
//                                       color: AppColors.primary,
//                                       height: 1.5,
//                                       fontSize: 12.fSize, decoration: TextDecoration.underline, fontWeight: FontWeight.w500))
//                                 ])),
//                             onPressed: (){
//                               context.push(AppRoutes.sign_up_form);
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
//         )
//     );
//   }
//
// }
