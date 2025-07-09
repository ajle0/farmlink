import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/provider/category/category_provider.dart';
import 'package:fluttermultigrocery/provider/product/search_product_provider.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/repository/category_repository.dart';
import 'package:fluttermultigrocery/repository/product_collection_repository.dart';
import 'package:fluttermultigrocery/repository/product_repository.dart';
import 'package:fluttermultigrocery/repository/shop_info_repository.dart';
import 'package:fluttermultigrocery/ui/dashboard/home/home_tabbar_slider.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/category.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ShopDashboardView extends StatefulWidget {
  const ShopDashboardView({super.key, required this.shopId, required this.shopName});

  final String shopId;
  final String shopName;

  @override
  _ShopDashboardViewState createState() => _ShopDashboardViewState();
}

class _ShopDashboardViewState extends State<ShopDashboardView> {
  PsValueHolder? valueHolder;
  CategoryRepository? repo1;
  ProductRepository? repo2;
  ProductCollectionRepository? repo3;
  ShopInfoRepository? shopInfoRepository;
  ShopInfoProvider? provider;
  CategoryProvider? _categoryProvider;
  final int count = 8;
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider!
          .loadCategoryList(_categoryProvider!.latestCategoryParameterHolder);
    }
  }

  SearchProductProvider? searchProductProvider;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ShopInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider = ShopInfoProvider(
                  repo: shopInfoRepository,
                  psValueHolder: valueHolder,
                  ownerCode: 'ShopDashboardView');
              provider!.loadShopInfo(widget.shopId);
              return provider!;
            }),
        ChangeNotifierProvider<CategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              _categoryProvider ??= CategoryProvider(
                  repo: repo1!,
                  psValueHolder: valueHolder,
                  limit: valueHolder!.categoryLoadingLimit!);
              _categoryProvider!.latestCategoryParameterHolder.shopId =
                  widget.shopId;
              _categoryProvider!.loadCategoryList(
                  _categoryProvider!.latestCategoryParameterHolder);
              return _categoryProvider!;
            }),
      ],
      child: Container(
        // color: PsColors.white,
        child:

            ///
            /// category List Widget
            ///
            _HomeCategoryHorizontalListWidget(
                shopInfoProvider: provider,
                shopId: widget.shopId,
                shopName: widget.shopName,
                psValueHolder: valueHolder!,
                // animationController: widget.animationController,
                userInputItemNameTextEditingController:
                    userInputItemNameTextEditingController), //animation
      ),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {required this.shopInfoProvider,
      required this.shopId,
      required this.shopName,
      required this.psValueHolder,
      required this.userInputItemNameTextEditingController});

  final ShopInfoProvider? shopInfoProvider;
  final String shopId;
  final String shopName;
  final PsValueHolder psValueHolder;
  final TextEditingController userInputItemNameTextEditingController;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

bool showMainMenu = true;
bool showSpecialCollections = true;
bool showFeaturedItems = true;

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.psValueHolder.showMainMenu != null &&
        widget.psValueHolder.showMainMenu == PsConst.ONE) {
          showMainMenu = true;
      } else {
          showMainMenu = false;
      }
    if (widget.psValueHolder.showSpecialCollections != null &&
        widget.psValueHolder.showSpecialCollections == PsConst.ONE) {
          showSpecialCollections = true;
      } else {
          showSpecialCollections = false;
      }
    if (widget.psValueHolder.showFeaturedItems != null &&
        widget.psValueHolder.showFeaturedItems == PsConst.ONE) {
          showFeaturedItems = true;
      } else {
          showFeaturedItems = false;
      }
    return Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget? child) {
        if (categoryProvider.categoryList.data == null ||
            categoryProvider.categoryList.data!.isEmpty ||
           // widget.shopInfoProvider == null ||
            widget.shopInfoProvider!.shopInfo.data == null) {
          return Container();
        }

        final List<Category> tmpList =
            List<Category>.from(categoryProvider.categoryList.data!);
        int i = 0;

        if (showMainMenu) {
          tmpList.insert(
              i,
              Category(
                  id: PsConst.mainMenu,
                  name: Utils.getString(context, 'dashboard__main_menu')));
          i++;
        }

        if (showFeaturedItems) {
          tmpList.insert(
              i,
              Category(
                  id: PsConst.featuredItem,
                  name: Utils.getString(context, 'dashboard__featured_items')));
        }

        if (showSpecialCollections) {
          tmpList.insert(
              i,
              Category(
                  id: PsConst.specialCollection,
                  name: Utils.getString(
                      context, 'dashboard__special_collection')));
        }
        return HomeTabbarProductListView(
            shopInfo: widget.shopInfoProvider!.shopInfo.data!,
            shopId: widget.shopId,
            shopName: widget.shopName,
            categoryList: tmpList, //categoryProvider.categoryList.data,
            userInputItemNameTextEditingController:
                widget.userInputItemNameTextEditingController,
            valueHolder: widget.psValueHolder,
            key: Key('${tmpList.length}'));
      },
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    required this.headerName,
    // this.productCollectionHeader,
    required this.viewAllClicked,
  });

  final String headerName;
  final Function? viewAllClicked;
  // final ProductCollectionHeader? productCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
