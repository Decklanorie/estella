import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:estella/shared/widgets/snackbar_service.dart';


doForEnv (Function development,Function production){
  if(dotenv.env['ENVIRONMENT'] == 'development'){
    development();
  }else if(dotenv.env['ENVIRONMENT'] == 'production'){
    production();
  }
 }

developmentFunc (BuildContext context, {required Function cb, String? productionMessage}){
   if(dotenv.env['ENVIRONMENT'] == 'development'){
     cb();
   }else if(productionMessage!=null){
     SnackBarService.showSnackBar(message: productionMessage, context: context,comingSoon:true,);
   }
 }

productionFunc (BuildContext context, {required Function cb, String? developmentMessage}){
   if(dotenv.env['ENVIRONMENT'] == 'production'){
     cb();
   }else if(developmentMessage!=null){
     SnackBarService.showSnackBar(message: developmentMessage, context: context);
   }
 }
