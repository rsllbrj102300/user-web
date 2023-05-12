
import 'package:flutter/material.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/auth_provider.dart';
import 'package:djr_shopping/provider/order_provider.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/view/base/app_bar_base.dart';
import 'package:djr_shopping/view/base/custom_loader.dart';
import 'package:djr_shopping/view/base/not_login_screen.dart';
import 'package:djr_shopping/view/base/web_app_bar/web_app_bar.dart';
import 'package:djr_shopping/view/screens/order/widget/order_button.dart';
import 'package:djr_shopping/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : AppBarBase(),

      body: SafeArea(
        child: _isLoggedIn ? Scrollbar(
          child: Center(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child)
              => orderProvider.runningOrderList != null ? Column(
                children: [
                  SizedBox(
                    width: 1170,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OrderButton(title: getTranslated('active', context), isActive: true),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          OrderButton(title: getTranslated('past_order', context), isActive: false),
                        ],
                      ),
                    ),
                  ),

                  Expanded(child: OrderView(isRunning: orderProvider.isActiveOrder ? true : false))
                ],
              ) : Center(child: CustomLoader(color: Theme.of(context).primaryColor)),
            ),
          ),
        ) : NotLoggedInScreen(),
      ),
    );
  }
}
// Provider.of<OrderProvider>(context, listen: false).runningOrderList != null ? ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox() : SizedBox(),




