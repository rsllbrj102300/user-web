import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/splash_provider.dart';
import 'package:djr_shopping/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    ConnectivityResult _result = await connectivity.checkConnectivity();
    return _result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

      if (Provider.of<SplashProvider>(context, listen: false).firstTimeConnectionCheck) {
        Provider.of<SplashProvider>(context, listen: false).setFirstTimeConnectionCheck(false);
      } else {
        bool isNotConnected = result == ConnectivityResult.none;
        isNotConnected ? SizedBox() : showCustomSnackBar(isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context), context,isError: isNotConnected);

        /*ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));*/
      }
    });
  }
}
