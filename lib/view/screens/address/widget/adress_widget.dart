
import 'package:flutter/material.dart';
import 'package:djr_shopping/data/model/response/address_model.dart';
import 'package:djr_shopping/helper/route_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/location_provider.dart';
import 'package:djr_shopping/provider/theme_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/custom_snackbar.dart';
import 'package:djr_shopping/view/screens/address/add_new_address_screen.dart';
import 'package:provider/provider.dart';
class AddressWidget extends StatelessWidget {

  final AddressModel addressModel;
  final int index;
  AddressWidget({@required this.addressModel, @required this.index});

  @override
  Widget build(BuildContext context) {

      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () {

            // if(addressModel != null) {
            //   Navigator.push(context, MaterialPageRoute(builder: (_) => MapWidget(address: addressModel)));
            // }
          },
          child: Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: ColorResources.getCardBgColor(context),
              boxShadow: [
                BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  addressModel.addressType,
                                  style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                                Text(
                                  addressModel.address,
                                  style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.all(0),
                      onSelected: (String result) {
                        if (result == 'delete') {
                          showDialog(context: context, barrierDismissible: false, builder: (context) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ));
                          Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index,
                                  (bool isSuccessful, String message) {
                            Navigator.pop(context);
                                    showCustomSnackBar(message, context,isError: isSuccessful);
                              });
                        } else {
                          Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessage(message: '');
                          Navigator.of(context).pushNamed(
                            RouteHelper.getUpdateAddressRoute(
                              addressModel
                            ),
                            // arguments: AddNewAddressScreen(isEnableUpdate: true, address: addressModel),
                          );
                        }
                      },
                      itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(getTranslated('edit', context), style: poppinsMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(getTranslated('delete', context), style: poppinsMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}
