import 'package:flutter/material.dart';
import 'package:djr_shopping/data/model/body/place_order_body.dart';
import 'package:djr_shopping/data/model/response/cart_model.dart';
import 'package:djr_shopping/data/model/response/order_details_model.dart';
import 'package:djr_shopping/data/model/response/order_model.dart';
import 'package:djr_shopping/data/model/response/product_model.dart';
import 'package:djr_shopping/helper/date_converter.dart';
import 'package:djr_shopping/helper/price_converter.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/helper/route_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/main.dart';
import 'package:djr_shopping/provider/cart_provider.dart';
import 'package:djr_shopping/provider/localization_provider.dart';
import 'package:djr_shopping/provider/order_provider.dart';
import 'package:djr_shopping/provider/product_provider.dart';
import 'package:djr_shopping/provider/splash_provider.dart';
import 'package:djr_shopping/provider/theme_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../order_details_screen.dart';
class OrderCard extends StatelessWidget {
  const OrderCard({Key key, @required this.orderList, @required this.index}) : super(key: key);

  final List<OrderModel> orderList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
          spreadRadius: 1, blurRadius: 5,
        )],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //date and money
        Row(children: [
          Text(
            DateConverter.isoDayWithDateString(orderList[index].updatedAt),
            style: poppinsMedium.copyWith(color: ColorResources.getTextColor(context)),
          ),
          Expanded(child: SizedBox.shrink()),
          Text(
            PriceConverter.convertPrice(context, orderList[index].orderAmount),
            style: poppinsBold.copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
        SizedBox(height: 8),
        //Order list
        Text('${getTranslated('order_id', context)} #${orderList[index].id.toString()}', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //item position
        Row(children: [
          Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 16),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            '${getTranslated('order_is', context)} ${getTranslated(orderList[index].orderStatus, context)}',
            style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        SizedBox(
          height: 50,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // View Details Button
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  RouteHelper.getOrderDetailsRoute(orderList[index].id),
                  arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                );
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorResources.getGreyColor(context),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 100],
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(getTranslated('view_details', context),
                    style: poppinsRegular.copyWith(
                      color: Colors.black,
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    )),
              ),
            ),

            orderList[index].orderType != 'pos' ? Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  return Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                      return TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 2, color: Theme.of(context).primaryColor))),
                        onPressed: () async {
                          if(orderProvider.isActiveOrder) {
                            Navigator.of(context).pushNamed(RouteHelper.getOrderTrackingRoute(orderList[index].id));
                          }else {
                            List<OrderDetailsModel> orderDetails = await orderProvider.getOrderDetails(orderList[index].id.toString(), context);
                            List<CartModel> _cartList = [];
                            String _errorMessage;
                            Variations _variation;
                            String _error;

                             await Future.forEach(orderDetails, (orderDetail) async {
                               print('oder detail --- ${orderDetail.toJson()}');

                               Product _product;
                               try{
                                 _product = await productProvider.getProductDetails(
                                   context, '${orderDetail.productId}',
                                   Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                 );
                               }catch(e){
                                 _error = getTranslated('one_or_more_items_not_available', context);

                               }

                              if(_product != null) {
                                double price = _product.price;
                                int _stock = _product.totalStock;

                                List<String> _variationList = [];
                                for (int index = 0; index < productProvider.product.choiceOptions.length; index++) {
                                  _variationList.add(productProvider.product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
                                }
                                String variationType = '';
                                bool isFirst = true;
                                _variationList.forEach((variation) {
                                  if (isFirst) {
                                    variationType = '$variationType$variation';
                                    isFirst = false;
                                  } else {
                                    variationType = '$variationType-$variation';
                                  }
                                });

                                for (Variations variation in productProvider.product.variations) {
                                  if (variation.type == variationType) {
                                    price = variation.price;
                                    _variation = variation;
                                    _stock = variation.stock;
                                    break;
                                  }
                                }

                                CartModel _cartModel = CartModel(
                                    productProvider.product.id, productProvider.product.image.length > 0
                                    ? productProvider.product.image[0] : '', productProvider.product.name, price,
                                    PriceConverter.convertWithDiscount(price, productProvider.product.discount, productProvider.product.discountType),
                                    productProvider.quantity, _variation,
                                    (price-PriceConverter.convertWithDiscount(price, productProvider.product.discount, productProvider.product.discountType)),
                                    (price-PriceConverter.convertWithDiscount(price, productProvider.product.tax, productProvider.product.taxType)),
                                    productProvider.product.capacity, productProvider.product.unit, _stock,productProvider.product
                                );

                                if(Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) != null) {
                                  _errorMessage = '${_cartModel.product.name} ${getTranslated('is_already_in_cart', context)}';

                                }else if(_cartModel.stock < 1) {
                                  _errorMessage = '${_cartModel.product.name} ${getTranslated('is_out_of_stock', context)}';
                                }else{
                                  _cartList.add(_cartModel);
                                }

                              }



                            }).then((value) {
                              if(_error != null) {
                                showCustomSnackBar(_error, Get.context);
                              }else if (_errorMessage != null) {
                                 showCustomSnackBar(_errorMessage, context);
                               }else {
                                 if(_cartList.isNotEmpty){
                                   _cartList.forEach((_cartModel) {
                                     Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                                   });

                                   ResponsiveHelper.isMobilePhone()
                                       ? Provider.of<SplashProvider>(context, listen: false).setPageIndex(2)
                                       : Navigator.pushNamed(context, RouteHelper.cart);
                                 }
    }
                             });
                          }
                        },
                        child: Text(orderProvider.isActiveOrder
                            ?  getTranslated('track_your_order', context) : 'Re-Order',
                          style: poppinsRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                      );
                    }
                  );
                }
            ) : SizedBox.shrink(),


            //Track your Order Button
          ]),
        ),
      ]),
    );
  }
}
