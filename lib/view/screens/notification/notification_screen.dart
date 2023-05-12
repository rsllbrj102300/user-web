import 'package:flutter/material.dart';
import 'package:djr_shopping/helper/date_converter.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/notification_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/custom_app_bar.dart';
import 'package:djr_shopping/view/base/custom_loader.dart';
import 'package:djr_shopping/view/base/footer_view.dart';
import 'package:djr_shopping/view/base/no_data_screen.dart';
import 'package:djr_shopping/view/base/read_more_text.dart';
import 'package:djr_shopping/view/base/web_app_bar/web_app_bar.dart';
import 'package:djr_shopping/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../utill/images.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)): CustomAppBar(title: getTranslated('notification', context)),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            // ResponsiveHelper.isDesktop(context) ? notificationProvider.notificationList.length<=4 ? SizedBox(height: 150) : SizedBox(): SizedBox(),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
              child: Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, child) {
                    List<DateTime> _dateTimeList = [];
                    return notificationProvider.notificationList != null ? notificationProvider.notificationList.length > 0
                        ? Scrollbar(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.6),
                        child: ListView.builder(
                            itemCount: notificationProvider.notificationList.length,
                            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 350, vertical: 20) :  EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DateTime _originalDateTime = DateConverter.isoStringToLocalDate(notificationProvider.notificationList[index].createdAt);
                              DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                              bool _addTitle = false;
                              if(!_dateTimeList.contains(_convertedDate)) {
                                _addTitle = true;
                                _dateTimeList.add(_convertedDate);
                              }
                              return InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (BuildContext context) {
                                    return NotificationDialog(notificationModel: notificationProvider.notificationList[index]);
                                  });
                                },
                                hoverColor: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _addTitle ? Padding(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                                      child: Text(DateConverter.isoStringToLocalDateOnly(notificationProvider.notificationList[index].createdAt)),
                                    ) : SizedBox(),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5),
                                                child: Container(
                                                  height: 50, width: 50,
                                                  margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: FadeInImage.assetNetwork(
                                                      placeholder: Images.placeholder(context),
                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.notificationImageUrl}/${notificationProvider.notificationList[index].image}',
                                                      height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                              ) ,
                                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                              Expanded(
                                                child: ListTile(
                                                 contentPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    notificationProvider.notificationList[index].title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: poppinsBold.copyWith(
                                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                                    ),
                                                  ),
                                                  subtitle: Text(notificationProvider.notificationList[index].description,
                                                    style: poppinsLight.copyWith(
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 10),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Container(height: 1, color: ColorResources.getGreyColor(context).withOpacity(.2))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                        : NoDataScreen()
                        : SizedBox(height: MediaQuery.of(context).size.height *0.6,child: Center(child: CustomLoader(color: Theme.of(context).primaryColor)));
                  }
              ),
            ),
            ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
          ],

        ),
      ),
    );
  }
}
