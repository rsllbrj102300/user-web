import 'package:flutter/material.dart';
import 'package:djr_shopping/localization/app_localization.dart';
import 'package:djr_shopping/view/base/custom_snackbar.dart';

String getTranslated(String key, BuildContext context) {
  String _text = key;
  try{
    _text = AppLocalization.of(context).translate(key);
  }catch (error){
    print('not localized --- $error');
  }
  return _text;
}