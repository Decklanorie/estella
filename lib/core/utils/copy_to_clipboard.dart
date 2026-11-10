import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:estella/shared/widgets/snackbar_service.dart';

void copyToClipboard(String text,String message, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text));
  SnackBarService.showSnackBar(message: message, context: context);
}