import 'package:flutter/material.dart';
import 'package:djr_shopping/data/model/response/category_model.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/helper/route_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/category_provider.dart';
import 'package:djr_shopping/provider/localization_provider.dart';
import 'package:djr_shopping/provider/product_provider.dart';
import 'package:djr_shopping/provider/splash_provider.dart';
import 'package:djr_shopping/provider/theme_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/utill/images.dart';
import 'package:djr_shopping/utill/styles.dart';
import 'package:djr_shopping/view/base/app_bar_base.dart';
import 'package:djr_shopping/view/base/custom_loader.dart';
import 'package:djr_shopping/view/base/main_app_bar.dart';
import 'package:djr_shopping/view/base/no_data_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: must_be_immutable
class AllCategoryScreen extends StatefulWidget {
  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {

  @override
  void initState() {
    super.initState();
    if(Provider.of<CategoryProvider>(context, listen: false).categoryList != null
        && Provider.of<CategoryProvider>(context, listen: false).categoryList.length > 0
    ) {
      _load();
    }else{
      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
        context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,true,
      ).then((apiResponse) {
        if(apiResponse.response.statusCode == 200 && apiResponse.response.data != null){
          _load();
        }

      });
    }

  }
  _load() async {
    final _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _categoryProvider.changeIndex(0, notify: false);
    if(_categoryProvider.categoryList.length > 0) {
      _categoryProvider.getSubCategoryList(context, _categoryProvider.categoryList[0].id.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ?  MainAppBar(): null,
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return categoryProvider.categoryList != null && categoryProvider.categoryList.length > 0
                  ? Row(children: [

                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 3),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200], spreadRadius: 3, blurRadius: 10)],
                        ),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            CategoryModel _category = categoryProvider.categoryList[index];
                            return InkWell(
                              onTap: () {
                                categoryProvider.changeIndex(index);
                                categoryProvider.getSubCategoryList(context, _category.id.toString(),
                                  Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
                              },
                              child: CategoryItem(
                                title: _category.name,
                                icon: _category.image,
                                isSelected: categoryProvider.categoryIndex == index,
                              ),
                            );
                          },
                        ),
                      ),

                      categoryProvider.subCategoryList != null
                          ? Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: categoryProvider.subCategoryList.length + 1,
                                itemBuilder: (context, index) {

                                  if(index == 0) {
                                    return ListTile(
                                      onTap: () {
                                        categoryProvider.changeSelectedIndex(-1);
                                        Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(
                                          categoryProvider.categoryList[categoryProvider.categoryIndex].id.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                        );
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getCategoryProductsRouteNew(
                                           categoryModel:  categoryProvider.categoryList[categoryProvider.categoryIndex],
                                          ),
                                        );
                                      },
                                      title: Text(getTranslated('all', context)),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                    );
                                  }
                                  return ListTile(
                                    onTap: () {
                                      categoryProvider.changeSelectedIndex(index-1);
                                      if(ResponsiveHelper.isMobilePhone()) {

                                      }
                                      Provider.of<ProductProvider>(context, listen: false).initCategoryProductList(
                                        categoryProvider.subCategoryList[index-1].id.toString(), context,
                                        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                      );

                                      Navigator.of(context).pushNamed(
                                        RouteHelper.getCategoryProductsRouteNew(
                                          categoryModel: categoryProvider.categoryList[categoryProvider.categoryIndex],
                                          subCategory: categoryProvider.subCategoryList[index-1].name,
                                        ),
                                      );
                                    },
                                    title: Text(categoryProvider.subCategoryList[index-1].name,
                                      style: poppinsMedium.copyWith(fontSize: 13, color: ColorResources.getTextColor(context)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: SubCategoryShimmer()),
                    ])
                  : categoryProvider.categoryList != null && categoryProvider.categoryList.length == 0
                  ? NoDataScreen(isNothing: true,) : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
            },
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;

  CategoryItem({@required this.title, @required this.icon, @required this.isSelected});

  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isSelected ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            //padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? ColorResources.getCategoryBgColor(context)
                    : ColorResources.getGreyLightColor(context).withOpacity(0.05)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder(context),
                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                fit: BoxFit.cover, width: 100, height: 100,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 100, width: 100, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: poppinsSemiBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: isSelected ? ColorResources.getBackgroundColor(context) : ColorResources.getTextColor(context)
                )),
          ),
        ]),
      ),
    );
  }
}

class SubCategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).subCategoryList == null,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
          ),
        );
      },
    );
  }
}
