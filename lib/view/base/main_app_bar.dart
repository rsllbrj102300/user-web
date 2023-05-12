import 'package:flutter/material.dart';
import 'package:djr_shopping/helper/route_helper.dart';
import 'package:djr_shopping/utill/app_constants.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/images.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/menu_bar.dart' as widget;


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).cardColor,
        width: 1170.0,
        height: 45.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, RouteHelper.menu),
                child: Row(
                children: [
                  Image.asset(Images.app_logo, color: Theme.of(context).primaryColor),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Text(AppConstants.APP_NAME, style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor)),
                ],
              )),
            ),
            widget.MenuBarWidget(),
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}