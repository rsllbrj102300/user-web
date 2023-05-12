import 'package:flutter/material.dart';
import 'package:djr_shopping/helper/html_type.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/splash_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/app_bar_base.dart';
import 'package:djr_shopping/view/base/footer_view.dart';
import 'package:djr_shopping/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});
  
  @override
  Widget build(BuildContext context) {
    final _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    String _data = 'no_data_found';
    String _appBarText = '';

    switch (htmlType) {
      case HtmlType.TERMS_AND_CONDITION :
        _data = _configModel.termsAndConditions ?? '';
        _appBarText = 'terms_and_condition';
        break;
      case HtmlType.ABOUT_US :
        _data = _configModel.aboutUs ?? '';
        _appBarText = 'about_us';
        break;
      case HtmlType.PRIVACY_POLICY :
        _data = _configModel.privacyPolicy ?? '';
        _appBarText = 'privacy_policy';
        break;
      case HtmlType.FAQ:
        _data = _configModel.faq ?? '';
        _appBarText = 'faq';
        break;
      case HtmlType.CANCELLATION_POLICY:
        _data = _configModel.cancellationPolicy ?? '';
        _appBarText = 'cancellation_policy';
        break;
      case HtmlType.REFUND_POLICY:
        _data = _configModel.refundPolicy ?? '';
        _appBarText = 'refund_policy';
        break;
      case HtmlType.RETURN_POLICY:
        _data = _configModel.returnPolicy ?? '';
        _appBarText = 'return_policy';
        break;
    }


    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : ResponsiveHelper.isMobilePhone() ? null : AppBarBase(
        title: getTranslated(_appBarText, context),
      ),
      body: SingleChildScrollView(child: Column(children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context)
              ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
          child: Container(
            width: 1170,
            color: Theme.of(context).canvasColor,
            child:  SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                ResponsiveHelper.isDesktop(context)
                    ? Text(htmlType.name.replaceAll('_', ' '), style: poppinsBold.copyWith(fontSize: 28,color: ColorResources.getTextColor(context)))
                    : SizedBox.shrink(),

                Padding(
                  padding: ResponsiveHelper.isDesktop(context)
                      ? const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_SMALL)
                      : const EdgeInsets.all(0.0),
                  child: HtmlWidget(
                    _data ?? '',
                    key: Key(htmlType.toString()),
                    textStyle: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                    onTapUrl: (String url){
                      return launchUrlString(url);
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),

        ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

        ]),
      ),
    );
  }
}