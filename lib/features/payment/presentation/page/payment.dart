import 'package:estella/core/theme/app_spacing.dart';
import 'package:estella/core/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/core/theme/app_text_styles.dart';
import 'package:estella/core/theme/app_theme.dart';
import 'package:estella/core/utils/size.dart';
import 'package:estella/shared/widgets/custom_elevated_button.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController _infoController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _plateController = TextEditingController();
  String type = 'saloon';

  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = ISize.wh(context);
    double h = ISize.hh(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          // Status bar background color
          statusBarIconBrightness: Brightness.dark,
          // Status bar icon brightness
          systemNavigationBarColor: AppColors.background,
          // Navigation bar background color
          systemNavigationBarIconBrightness:
          Brightness.dark, // Navigation bar icon brightness
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(),
            backgroundColor: AppColors.universalWhite,
            title: Text(
              'Payment',
              style: theme.textTheme.BodyTextBigMedium.copyWith(fontSize: 16),
            ),
          ),
          body: SafeArea(
              child: Container(
                width: w,
                height: h,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children:  [
                    addVerticalSpace(120),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 0)),
                          ],
                        ),
                        child: Center(
                            child: Icon(Icons.account_balance, size: 50, color: Colors.lightGreen,),
                        )),

                    addVerticalSpace(AppSpacing.inputVerticalSpacing),
                    addVerticalSpace(AppSpacing.inputVerticalSpacing),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: Text.rich(
                      TextSpan(
                          text:
                          'your bill is ',
                          children: [
                            TextSpan(
                              text:
                              '4,000.00 naira. ',
                              style:
                              theme.textTheme.BodyTextSmallRegular.copyWith(
                                  fontWeight: FontWeight.w600
                              ),
                            ),

                            TextSpan(
                              text:
                              'Kindly make transfer to the ',
                            ),

                            TextSpan(
                              text:
                              'Opay ',
                              style:
                              theme.textTheme.BodyTextSmallRegular.copyWith(
                                  fontWeight: FontWeight.w600
                              ),
                            ),

                            TextSpan(
                              text:
                              'account number below and click the "I\'ve sent the money" Button',
                            ),
                          ]
                      ),
                      style:
                      theme.textTheme.BodyTextSmallRegular.copyWith(
                        height: 1.7
                      ),
                      textAlign: TextAlign.center,
                    ),),

                    addVerticalSpace(AppSpacing.inputVerticalSpacing),
                    addVerticalSpace(AppSpacing.inputVerticalSpacing),
                    Text(
                      '090 1234 5678.',
                      style:
                      theme.textTheme.BodyTextSmallRegular.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22
                      ),
                    )
                  ],
                ),
              )),
          bottomNavigationBar: Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: w,
            child: CustomElevatedButton(
              onPressed: () async {},
              text: "I've sent the money",
              buttonTextStyle: Theme.of(context)
                  .textTheme
                  .BodyTextSmallMediumAuto
                  .copyWith(color: AppColors.universalWhite),
            ),
          ),
        ));
  }
}
