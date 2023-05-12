import 'package:flutter/material.dart';
import 'package:djr_shopping/data/model/response/language_model.dart';
import 'package:djr_shopping/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
