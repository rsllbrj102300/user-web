import 'package:flutter/material.dart';
import 'package:djr_shopping/data/model/response/product_model.dart';
import 'package:djr_shopping/helper/product_type.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/provider/flash_deal_provider.dart';
import 'package:djr_shopping/provider/product_provider.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/view/base/product_widget.dart';
import 'package:djr_shopping/view/base/web_product_shimmer.dart';
import 'package:provider/provider.dart';

class HomeItemView extends StatelessWidget {
  final List<Product> productList;

  const HomeItemView({Key key, this.productList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(builder: (context, flashDealProvider, child) {
        return Consumer<ProductProvider>(builder: (context, productProvider, child) {

          return productList != null ? Column(children: [

            ResponsiveHelper.isDesktop(context) ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:  (1 / 1.1),
                crossAxisCount: 5,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
              ),
              itemCount: productList.length >= 10 ? 10 : productList.length,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL,
                vertical: Dimensions.PADDING_SIZE_LARGE,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context,index){
                return ProductWidget(
                  isGrid: true,
                  product: productList[index],
                  productType: ProductType.DAILY_ITEM,
                );
                },
            ) :
            SizedBox(
              height: 290,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                itemCount: productList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 195,
                    padding: EdgeInsets.all(5),
                    child: ProductWidget(
                      isGrid: true,
                      product: productList[index],
                      productType: ProductType.DAILY_ITEM,
                    ),
                  );
                  },
              ),
            ),

          ]) : ResponsiveHelper.isDesktop(context) ?
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:  (1 / 1.3),
              crossAxisCount: 5,
              mainAxisSpacing: 13,
              crossAxisSpacing: 13,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => WebProductShimmer(isEnabled: true),
          ) :
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 195,
                  padding: EdgeInsets.all(5),
                  child: WebProductShimmer(isEnabled: true),
                );
              },
            ),
          );
        });
      }
    );
  }
}



