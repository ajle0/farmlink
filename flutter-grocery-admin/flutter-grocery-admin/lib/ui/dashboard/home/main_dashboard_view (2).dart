import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/basket/basket_provider.dart';
import 'package:fluttermultigrocery/provider/best_choice/best_choice_provider.dart';
import 'package:fluttermultigrocery/provider/category/category_provider.dart';
import 'package:fluttermultigrocery/provider/product/discount_product_provider.dart';
import 'package:fluttermultigrocery/provider/product/search_product_provider.dart';
import 'package:fluttermultigrocery/provider/product/trending_product_provider.dart';
import 'package:fluttermultigrocery/provider/shop/new_shop_provider.dart';
import 'package:fluttermultigrocery/provider/shop/trending_shop_provider.dart';
import 'package:fluttermultigrocery/repository/basket_repository.dart';
import 'package:fluttermultigrocery/repository/best_choice_repository.dart';
import 'package:fluttermultigrocery/repository/category_repository.dart';
import 'package:fluttermultigrocery/repository/product_collection_repository.dart';
import 'package:fluttermultigrocery/repository/product_repository.dart';
import 'package:fluttermultigrocery/repository/shop_info_repository.dart';
import 'package:fluttermultigrocery/repository/shop_repository.dart';
import 'package:fluttermultigrocery/ui/best_choice/best_choice_list_collection_id_view.dart';
import 'package:fluttermultigrocery/ui/best_choice/best_choice_list_item_view.dart';
import 'package:fluttermultigrocery/ui/best_choice/best_choice_slider/best_choice_slider_view.dart';
import 'package:fluttermultigrocery/ui/category/item/category_horizontal_list_item.dart';
import 'package:fluttermultigrocery/ui/common/dialog/choose_attribute_dialog.dart';
import 'package:fluttermultigrocery/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/dialog/rating_dialog/core.dart';
import 'package:fluttermultigrocery/ui/common/dialog/rating_dialog/style.dart';
import 'package:fluttermultigrocery/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultigrocery/ui/map/home_location_view.dart';
import 'package:fluttermultigrocery/ui/product/item/product_horizontal_list_item.dart';
import 'package:fluttermultigrocery/ui/shop_list/item/shop_horizontal_list_item.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';
import 'package:fluttermultigrocery/viewobject/basket_selected_add_on.dart';
import 'package:fluttermultigrocery/viewobject/basket_selected_attribute.dart';
import 'package:fluttermultigrocery/viewobject/best_choice.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/shop_list_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/shop_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class MainDashboardViewWidget extends StatefulWidget {
  const MainDashboardViewWidget(
    this.animationController,
    this.context, {super.key}
  );

  final AnimationController animationController;
  final BuildContext context;

  @override
  _MainDashboardViewWidgetState createState() =>
      _MainDashboardViewWidgetState();
}

class _MainDashboardViewWidgetState extends State<MainDashboardViewWidget> {
  PsValueHolder? valueHolder;
  CategoryRepository? repo1;
  ProductRepository? repo2;
  ProductCollectionRepository? repo3;
  ShopInfoRepository? shopInfoRepository;
  TrendingShopProvider? trendingShopProvider;
  NewShopProvider? newShopProvider;
  ShopRepository? shopRepository;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  TextEditingController searchTextController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TrendingProductProvider? _trendingProductProvider;
  DiscountProductProvider? _discountProductProvider;
  CategoryProvider? _categoryProvider;
  BestChoiceRepository? bestChoiceRepository;
  BestChoiceProvider? bestChoiceProvider;
  final int count = 8;
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  BasketSelectedAddOn basketSelectedAddOn = BasketSelectedAddOn();
  bool showBestChoiceSlider = true;
  String? selectedShopId = 'all';
  String? selectedShopName = 'All Shops';

  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 5,
      remindLaunches: 1);

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider!
          .loadCategoryList(_categoryProvider!.latestCategoryParameterHolder);
    }

    if (Platform.isAndroid) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
            message: Utils.getString(context, 'rating_popup_dialog_message'),
            ignoreNativeDialog: true,
            actionsBuilder: (BuildContext context, double? stars) {
              return <Widget>[
                TextButton(
                  child: Text(
                    Utils.getString(context, 'dialog__ok'),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // _rateMyApp.save().then((void v) => Navigator.pop(context));
                      Navigator.pop(context);
                      if (stars < 1) {
                      } else if (stars >= 1 && stars <= 3) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.laterButtonPressed);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'rating_confirm_message'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText: Utils.getString(
                                    context, 'home__menu_drawer_contact_us'),
                                onAgreeTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.contactUs,
                                  );
                                },
                              );
                            });
                      } else if (stars >= 4) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ];
            },
            onDismissed: () =>
                _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 16.0),
            ),
            starRatingOptions: const StarRatingOptions(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    shopRepository = Provider.of<ShopRepository>(context);
    bestChoiceRepository = Provider.of<BestChoiceRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (valueHolder!.showBestChoiceSlider != null &&
        valueHolder!.showBestChoiceSlider == PsConst.ONE) {
        showBestChoiceSlider = true;
      } else {
        showBestChoiceSlider = false;
    }

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<NewShopProvider>(
              lazy: false,
              create: (BuildContext context) {
                newShopProvider = NewShopProvider(
                    repo: shopRepository, 
                    psValueHolder: valueHolder,
                    limit: valueHolder!.shopLoadingLimit!);
                return newShopProvider!;
              }),
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1!,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.categoryLoadingLimit!);
                _categoryProvider!
                    .loadCategoryList(
                        _categoryProvider!.latestCategoryParameterHolder)
                    .then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _categoryProvider!;
              }),
          ChangeNotifierProvider<SearchProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                final SearchProductProvider provider = SearchProductProvider(
                    repo: repo2!, 
                    psValueHolder: valueHolder,
                    limit: valueHolder!.latestProductLoadingLimit!);
                // provider.latestProductParameterHolder.shopId = widget.shopId;
                provider.loadProductListByKey(
                    provider.latestProductParameterHolder);
                return provider;
              }),
          ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.discountProductLoadingLimit!);
                // provider.discountProductParameterHolder.shopId = widget.shopId;
                _discountProductProvider!.loadProductList(
                    _discountProductProvider!.discountProductParameterHolder);
                return _discountProductProvider!;
              }),
          ChangeNotifierProvider<TrendingProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _trendingProductProvider = TrendingProductProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.trendingProductLoadingLimit!);
                // provider.trendingProductParameterHolder.shopId = widget.shopId;
                _trendingProductProvider!.loadProductList(
                    _trendingProductProvider!.trendingProductParameterHolder);
                return _trendingProductProvider!;
              }),
          ChangeNotifierProvider<TrendingShopProvider>(
              lazy: false,
              create: (BuildContext context) {
                trendingShopProvider = TrendingShopProvider(
                    repo: shopRepository,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.shopLoadingLimit!);
                trendingShopProvider!.loadShopList();
                return trendingShopProvider!;
              }),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                basketProvider = BasketProvider(
                  repo: basketRepository,
                  psValueHolder: valueHolder);
                basketProvider!.loadBasketList();
                return basketProvider!;
          }),
          ChangeNotifierProvider<BestChoiceProvider>(
              lazy: false,
              create: (BuildContext context) {
                bestChoiceProvider =
                    BestChoiceProvider(
                      repo: bestChoiceRepository,
                      psValueHolder: valueHolder);
                bestChoiceProvider!.loadBestChoiceList();
                return bestChoiceProvider!;
          }),
        ],
        child: Container(
          color: PsColors.baseLightColor,
          child: RefreshIndicator(
            onRefresh: () {
              _trendingProductProvider!.resetTrendingProductList(
                  _trendingProductProvider!.trendingProductParameterHolder);
              _discountProductProvider!.resetDiscountProductList(
                  _discountProductProvider!.discountProductParameterHolder);
              trendingShopProvider!.refreshShopList();
              return _categoryProvider!
                  .resetCategoryList(
                      _categoryProvider!.latestCategoryParameterHolder)
                  .then((dynamic value) {
                // Utils.psPrint("Is Has Internet " + value);
                final bool isConnectedToIntenet = value ?? bool;
                if (!isConnectedToIntenet) {
                  Fluttertoast.showToast(
                      msg: 'No Internet Connectiion. Please try again !',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white);
                }
              });
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: HomeLocationWidget(
                        androidFusedLocation: true,
                        textEditingController: addressController,
                        searchTextController: searchTextController,
                        valueHolder: valueHolder!,
                        selectedShopId: selectedShopId,
                        selectedShopName: selectedShopName,
                        onShopChanged: (String? newShopId, String? newShopName) {
                          setState(() {
                            selectedShopId = newShopId;
                            selectedShopName = newShopName;
                          });
                          // Trigger product/category reloads here if needed
                        },
                    )),

                ///
                /// category List Widget
                ///
                SliverToBoxAdapter(
                  child: _HomeCategoryHorizontalListWidget(
                    psValueHolder: valueHolder!,
                    animationController: widget.animationController,
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * 2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    selectedShopId: selectedShopId ?? 'all',
                  ),
                ),
                _HomeNewShopHorizontalListWidget(
                  psValueHolder: valueHolder!,
                  animationController:
                      widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                _HomeTrendingProductHorizontalListWidget(
                  animationController: widget.animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAddOn: basketSelectedAddOn,
                  basketSelectedAttribute: basketSelectedAttribute,
                  selectedShopId: selectedShopId ?? 'all',
                ),
                _DiscountProductHorizontalListWidget(
                  animationController: widget.animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAddOn: basketSelectedAddOn,
                  basketSelectedAttribute: basketSelectedAttribute,
                  selectedShopId: selectedShopId ?? 'all',
                ),
                _HomePopularShopHorizontalListWidget(
                  psValueHolder: valueHolder!,
                  animationController:
                      widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 6, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
              ],
            ),
          ),
        ));
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget({
    required this.psValueHolder,
    required this.animationController,
    required this.animation,
    required this.selectedShopId,
  });

  final PsValueHolder psValueHolder;
  final AnimationController animationController;
  final Animation<double> animation;
  final String selectedShopId;

  @override
  __HomeCategoryHorizontalListWidgetState createState() => __HomeCategoryHorizontalListWidgetState();
}

bool isShowSubCategory = false;

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.psValueHolder.isShowSubCategory != null &&
        widget.psValueHolder.isShowSubCategory == PsConst.ONE) {
        isShowSubCategory = true;
    } else {
        isShowSubCategory = false;
    }
    return Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider, Widget? child) {
        // Patch: Set shopId in parameter holder only if not 'all'
        if (widget.selectedShopId != null && widget.selectedShopId != 'all') {
          categoryProvider.latestCategoryParameterHolder.shopId = widget.selectedShopId;
        } else {
          categoryProvider.latestCategoryParameterHolder.shopId = '';
        }
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space140,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categoryList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // DEBUG PRINT: Category info
                            print('Category: \'${categoryProvider.categoryList.data![index].name}\' - ID: \'${categoryProvider.categoryList.data![index].id}\'');
                            if (categoryProvider.categoryList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data![index],
                                onTap: () {
                                  final String loginUserId =
                                      Utils.checkUserLoginId(
                                          widget.psValueHolder);
                                  final TouchCountParameterHolder
                                      touchCountParameterHolder =
                                      TouchCountParameterHolder(
                                          typeId: categoryProvider
                                              .categoryList.data![index].id,
                                          typeName: PsConst
                                              .FILTERING_TYPE_NAME_CATEGORY,
                                          userId: loginUserId,
                                          shopId: widget.selectedShopId);

                                  categoryProvider.postTouchCount(
                                      touchCountParameterHolder.toMap());
                                  if (isShowSubCategory) {
                                    Navigator.pushNamed(
                                        context, RoutePaths.subCategoryGrid,
                                        arguments: categoryProvider
                                            .categoryList.data![index]);
                                  } else {
                                    final ProductParameterHolder
                                        productParameterHolder =
                                        ProductParameterHolder()
                                            .getLatestParameterHolder();
                                    productParameterHolder.catId =
                                        categoryProvider
                                            .categoryList.data![index].id;
                                    // DEBUG PRINT: Product filter params
                                    print('Filtering products for category: \'${categoryProvider.categoryList.data![index].name}\' - ID: \'${categoryProvider.categoryList.data![index].id}\'');
                                    Navigator.pushNamed(
                                        context, RoutePaths.filterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: categoryProvider
                                              .categoryList.data![index].name,
                                          productParameterHolder:
                                              productParameterHolder,
                                        ));
                                  }
                                },
                                // )
                              );
                            }
                          }),
                    ),
                    const SizedBox(height: PsDimens.space8),
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30 * (1.0 - widget.animation.value), 0.0),
                    child: child,
                  ));
            });
      },
    );
  }
}

class _HomeNewShopHorizontalListWidget extends StatefulWidget {
  const _HomeNewShopHorizontalListWidget(
      {required this.animationController,
      required this.animation,
      required this.psValueHolder});

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeNewShopHorizontalListWidgetState createState() =>
      __HomeNewShopHorizontalListWidgetState();
}

class __HomeNewShopHorizontalListWidgetState
    extends State<_HomeNewShopHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isShowAdmob = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && isShowAdmob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.psValueHolder.isShowAdmob != null &&
        widget.psValueHolder.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }
    return SliverToBoxAdapter(
      child: Consumer<NewShopProvider>(
        builder: (BuildContext context, NewShopProvider newShopProvider,
            Widget? child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              child: (newShopProvider.shopList.data != null &&
                      newShopProvider.shopList.data!.isNotEmpty)
                  ? Column(children: <Widget>[
                      Container(
                        color: PsColors.backgroundColor,
                        child: _MyHeaderWidget(
                          headerName: Utils.getString(
                              context, 'shop_dashboard__shop_near_you'),
                          viewAllClicked: () {
                            Navigator.pushNamed(context, RoutePaths.shopList,
                                arguments: ShopListIntentHolder(
                                  appBarTitle: Utils.getString(
                                      context, 'shop_dashboard__shop_near_you'),
                                  shopParameterHolder: newShopProvider
                                      .shopNearYouParameterHolder,
                                ));
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: PsDimens.space16,
                      //       right: PsDimens.space16,
                      //       bottom: PsDimens.space16),
                      // child:
                      Container(
                          color: PsColors.backgroundColor,
                          height: PsDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              itemCount: newShopProvider.shopList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (newShopProvider.shopList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ShopHorizontalListItem(
                                    shop: newShopProvider.shopList.data![index],
                                    onTap: () {
                                      final String loginUserId =
                                          Utils.checkUserLoginId(
                                              widget.psValueHolder);

                                      final TouchCountParameterHolder
                                          touchCountParameterHolder =
                                          TouchCountParameterHolder(
                                              typeId: newShopProvider
                                                  .shopList.data![index].id,
                                              typeName: PsConst
                                                  .FILTERING_TYPE_NAME_SHOP,
                                              userId: loginUserId,
                                              shopId: newShopProvider
                                                  .shopList.data![index].id);
                                      newShopProvider.postTouchCount(
                                          touchCountParameterHolder.toMap());

                                      newShopProvider.replaceShop(
                                          newShopProvider
                                              .shopList.data![index].id!,
                                          newShopProvider
                                              .shopList.data![index].name!);
                                      Navigator.pushNamed(
                                          context, RoutePaths.shop_dashboard,
                                          arguments: ShopDataIntentHolder(
                                              shopId: newShopProvider
                                                  .shopList.data![index].id,
                                              shopName: newShopProvider
                                                  .shopList.data![index].name));
                                    },
                                  );
                                }
                              })),
                      const SizedBox(height: PsDimens.space8),
                    ])
                  : Container(),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child,
                  ),
                );
              });
        },
      ),
    );
  }
}

class _HomePopularShopHorizontalListWidget extends StatefulWidget {
  const _HomePopularShopHorizontalListWidget(
      {required this.animationController,
      required this.animation,
      required this.psValueHolder});

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomePopularShopHorizontalListWidgetState createState() =>
      __HomePopularShopHorizontalListWidgetState();
}

class __HomePopularShopHorizontalListWidgetState
    extends State<_HomePopularShopHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<TrendingShopProvider>(
        builder: (BuildContext context, TrendingShopProvider shopProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (shopProvider.shopList.data != null &&
                    shopProvider.shopList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    Container(
                      color: PsColors.backgroundColor,
                      child: _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'shop_dashboard__trending_shop'),
                        viewAllClicked: () {
                          Navigator.pushNamed(context, RoutePaths.shopList,
                              arguments: ShopListIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'shop_dashboard__trending_shop'),
                                shopParameterHolder: ShopParameterHolder()
                                    .getTrendingShopParameterHolder(),
                              ));
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: PsDimens.space16,
                    //       right: PsDimens.space16,
                    //       bottom: PsDimens.space16),
                    //   child:
                    Container(
                        color: PsColors.backgroundColor,
                        height: 900,
                        width: MediaQuery.of(context).size.width,
                        child: RefreshIndicator(
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                      PsDimens.space16, 0, PsDimens.space16, 0),
                                  sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 350,
                                              childAspectRatio: 1.0),
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          if (shopProvider.shopList.status ==
                                              PsStatus.BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor: PsColors.grey,
                                                highlightColor: PsColors.white,
                                                child: Row(
                                                    children: const <Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            return ShopHorizontalListItem(
                                              shop: shopProvider
                                                  .shopList.data![index],
                                              onTap: () async {
                                                final String loginUserId =
                                                    Utils.checkUserLoginId(
                                                        widget.psValueHolder);

                                                final TouchCountParameterHolder
                                                    touchCountParameterHolder =
                                                    TouchCountParameterHolder(
                                                        typeId: shopProvider
                                                            .shopList
                                                            .data![index]
                                                            .id,
                                                        typeName: PsConst
                                                            .FILTERING_TYPE_NAME_SHOP,
                                                        userId: loginUserId,
                                                        shopId: shopProvider
                                                            .shopList
                                                            .data![index]
                                                            .id);
                                                shopProvider.postTouchCount(
                                                    touchCountParameterHolder
                                                        .toMap());

                                                shopProvider.replaceShop(
                                                    shopProvider.shopList
                                                        .data![index].id!,
                                                    shopProvider.shopList
                                                        .data![index].name!);
                                                final dynamic result =
                                                    await Navigator.pushNamed(
                                                        context,
                                                        RoutePaths
                                                            .shop_dashboard,
                                                        arguments:
                                                            ShopDataIntentHolder(
                                                                shopId:
                                                                    shopProvider
                                                                        .shopList
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                shopName:
                                                                    shopProvider
                                                                        .shopList
                                                                        .data![
                                                                            index]
                                                                        .name));

                                                if (result != null && result) {
                                                  setState(() {
                                                    shopProvider
                                                        .refreshShopList();
                                                  });
                                                }
                                              },
                                            );
                                          }
                                        },
                                        childCount:
                                            shopProvider.shopList.data!.length,
                                      )))
                            ],
                          ),
                          onRefresh: () {
                            return shopProvider.refreshShopList();
                          },
                        )),
                    const SizedBox(height: PsDimens.space8),
                    // )
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeTrendingProductHorizontalListWidget extends StatefulWidget {
  const _HomeTrendingProductHorizontalListWidget({
    required this.animationController,
    required this.animation,
    required this.bottomSheetPrice,
    required this.totalOriginalPrice,
    required this.basketSelectedAddOn,
    required this.basketSelectedAttribute,
    required this.selectedShopId
  });

  final AnimationController animationController;
  final Animation<double> animation;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAddOn basketSelectedAddOn;
  final BasketSelectedAttribute basketSelectedAttribute;
  final String selectedShopId;

    @override
  __HomeTrendingProductHorizontalListWidgetState createState() =>
      __HomeTrendingProductHorizontalListWidgetState();
}

class __HomeTrendingProductHorizontalListWidgetState
    extends State<_HomeTrendingProductHorizontalListWidget> {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;

  @override
  Widget build(BuildContext context) {
    final BasketProvider basketProvider =
          Provider.of<BasketProvider>(context, listen: false);
    return SliverToBoxAdapter(
      child: Consumer<TrendingProductProvider>(
        builder: (BuildContext context, TrendingProductProvider productProvider,
            Widget ?child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      Container(
                        color: PsColors.backgroundColor,
                        child: _MyHeaderWidget(
                          headerName: Utils.getString(
                              context, 'dashboard__trending_product'),
                          viewAllClicked: () {
                            Navigator.pushNamed(
                                context, RoutePaths.filterProductList,
                                arguments: ProductListIntentHolder(
                                    appBarTitle: Utils.getString(
                                        context, 'dashboard__trending_product'),
                                    productParameterHolder:
                                        ProductParameterHolder()
                                            .getTrendingParameterHolder()));
                          },
                        ),
                      ),
                      Container(
                          color: PsColors.backgroundColor,
                          height: PsDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  productProvider.productList.data!.length,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!,
                                    product:
                                        productProvider.productList.data![index],
                                    onTap: () {
                                      print(productProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                        productId: product.id,
                                        heroTagImage: productProvider.hashCode
                                                .toString() +
                                            product.id!+
                                            PsConst.HERO_TAG__IMAGE,
                                        heroTagTitle: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__TITLE,
                                        heroTagOriginalPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                        heroTagUnitPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                      );
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                    onButtonTap: () async {
                                      id =
                                        '${product.id}$colorId${widget.basketSelectedAddOn.getSelectedaddOnIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                      if (product.minimumOrder == '0') {
                                        product.minimumOrder = '1' ;
                                      }
                                      basket = Basket(
                                        id: id,
                                        productId: product.id,
                                        qty: qty ?? product.minimumOrder,
                                        shopId: widget.selectedShopId == 'all' ? null : widget.selectedShopId,
                                        selectedColorId: colorId,
                                        selectedColorValue: colorValue,
                                        basketPrice: widget.bottomSheetPrice == null
                                            ? product.unitPrice
                                            : widget.bottomSheetPrice.toString(),
                                        basketOriginalPrice: widget.totalOriginalPrice == 0.0
                                            ? product.originalPrice
                                            : widget.totalOriginalPrice.toString(),
                                        selectedAttributeTotalPrice: widget.basketSelectedAttribute
                                            .getTotalSelectedAttributePrice()
                                            .toString(),
                                        product: product,
                                        basketSelectedAttributeList:
                                            widget.basketSelectedAttribute.getSelectedAttributeList(),
                                        basketSelectedAddOnList:
                                            widget.basketSelectedAddOn.getSelectedAddOnList());

                                        if (product.isAvailable == '1') {
                                          if (product.addOnList!.isNotEmpty &&
                                              product.addOnList![0].id != '' ||
                                              product.customizedHeaderList!.isNotEmpty &&
                                              product.customizedHeaderList![0].id != '' &&
                                              product.customizedHeaderList![0].customizedDetail != null) {
                                            showDialog<dynamic>(
                                                context: context,
                                              builder: (BuildContext context) {
                                                return ChooseAttributeDialog(
                                                  product: productProvider
                                                        .productList.data![index]);
                                                });
                                          } else {
                                            if (basketProvider.basketList.data!
                                                  .isNotEmpty &&
                                              product.shop!.id !=
                                                  basketProvider.basketList.data![0]
                                                  .shopId) {
                                            showDialog<dynamic>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ConfirmDialogView(
                                                    description: Utils.getString(context,
                                                        'warning_dialog__change_shop'),
                                                    leftButtonText: Utils.getString(context,
                                                        'basket_list__comfirm_dialog_cancel_button'),
                                                    rightButtonText: Utils.getString(
                                                        context,
                                                        'basket_list__comfirm_dialog_ok_button'),
                                                    onAgreeTap: () async {
                                                      await basketProvider
                                                        .deleteWholeBasketList();

                                                      await basketProvider.addBasket(basket!);
                                                      
                                                      Fluttertoast.showToast(
                                                        msg:
                                                          Utils.getString(context, 'product_detail__success_add_to_basket'),
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: PsColors.mainColor,
                                                        textColor: PsColors.white);

                                                        await Navigator.pushNamed(
                                                          context,
                                                          RoutePaths.basketList,
                                                      );
                                                    });         
                                                }); 
                                            } else {
                                              await basketProvider.addBasket(basket!);
                                                  
                                              Fluttertoast.showToast(
                                                msg:
                                                  Utils.getString(context, 'product_detail__success_add_to_basket'),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: PsColors.mainColor,
                                                textColor: PsColors.white);

                                                await Navigator.pushNamed(
                                                  context,
                                                  RoutePaths.basketList,
                                              );
                                            }
                                          }
                                        } else {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarningDialog(
                                                  message: Utils.getString(context,
                                                      'product_detail__is_not_available'),
                                                  onPressed: () {},
                                          );
                                        });
                                      }
                                    },
                                  );
                                }
                              })),
                      const SizedBox(height: PsDimens.space8),
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DiscountProductHorizontalListWidget extends StatefulWidget {
  const _DiscountProductHorizontalListWidget({
    required this.animationController,
    required this.animation,
    required this.bottomSheetPrice,
    required this.totalOriginalPrice,
    required this.basketSelectedAddOn,
    required this.basketSelectedAttribute,
    required this.selectedShopId
  });

  final AnimationController animationController;
  final Animation<double> animation;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAddOn basketSelectedAddOn;
  final BasketSelectedAttribute basketSelectedAttribute;
  final String selectedShopId;
  

  @override
  __DiscountProductHorizontalListWidgetState createState() =>
      __DiscountProductHorizontalListWidgetState();
}

class __DiscountProductHorizontalListWidgetState
    extends State<_DiscountProductHorizontalListWidget> {    
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isShowAdmob = true;
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && isShowAdmob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
          Provider.of<PsValueHolder>(context, listen: false);
    final BasketProvider basketProvider =
          Provider.of<BasketProvider>(context, listen: false);
    if (psValueHolder.isShowAdmob != null &&
        psValueHolder.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }
    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<DiscountProductProvider>(builder: (BuildContext context,
            DiscountProductProvider productProvider, Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  Container(
                    color: PsColors.backgroundColor,
                    child: _MyHeaderWidget(
                      headerName: Utils.getString(
                          context, 'dashboard__discount_product'),
                      viewAllClicked: () {
                        Navigator.pushNamed(
                            context, RoutePaths.filterProductList,
                            arguments: ProductListIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'dashboard__discount_product'),
                                productParameterHolder: ProductParameterHolder()
                                    .getDiscountParameterHolder()));
                      },
                    ),
                  ),
                  Container(
                      color: PsColors.backgroundColor,
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          itemCount: productProvider.productList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data![index];
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id!,
                                product:
                                    productProvider.productList.data![index],
                                onTap: () {
                                  print(productProvider.productList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    productId: product.id,
                                    heroTagImage:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                        productProvider.hashCode.toString() +
                                            product.id !+
                                            PsConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                                onButtonTap: () async {
                                      id =
                                        '${product.id}$colorId${widget.basketSelectedAddOn.getSelectedaddOnIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                      if (product.minimumOrder == '0') {
                                        product.minimumOrder = '1' ;
                                      }
                                      basket = Basket(
                                        id: id,
                                        productId: product.id,
                                        qty: qty ?? product.minimumOrder,
                                        shopId: widget.selectedShopId == 'all' ? null : widget.selectedShopId,
                                        selectedColorId: colorId,
                                        selectedColorValue: colorValue,
                                        basketPrice: widget.bottomSheetPrice == null
                                            ? product.unitPrice
                                            : widget.bottomSheetPrice.toString(),
                                        basketOriginalPrice: widget.totalOriginalPrice == 0.0
                                            ? product.originalPrice
                                            : widget.totalOriginalPrice.toString(),
                                        selectedAttributeTotalPrice: widget.basketSelectedAttribute
                                            .getTotalSelectedAttributePrice()
                                            .toString(),
                                        product: product,
                                        basketSelectedAttributeList:
                                            widget.basketSelectedAttribute.getSelectedAttributeList(),
                                        basketSelectedAddOnList:
                                            widget.basketSelectedAddOn.getSelectedAddOnList());

                                        if (product.isAvailable == '1') {
                                          if (product.addOnList!.isNotEmpty &&
                                              product.addOnList![0].id != '' ||
                                              product.customizedHeaderList!.isNotEmpty &&
                                              product.customizedHeaderList![0].id != '' &&
                                              product.customizedHeaderList![0].customizedDetail != null) {
                                            showDialog<dynamic>(
                                                context: context,
                                              builder: (BuildContext context) {
                                                return ChooseAttributeDialog(
                                                  product: productProvider
                                                        .productList.data![index]);
                                                });
                                          } else {
                                            if (basketProvider.basketList.data!
                                                  .isNotEmpty &&
                                              product.shop!.id !=
                                                  basketProvider.basketList.data![0]
                                                  .shopId) {
                                            showDialog<dynamic>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ConfirmDialogView(
                                                    description: Utils.getString(context,
                                                        'warning_dialog__change_shop'),
                                                    leftButtonText: Utils.getString(context,
                                                        'basket_list__comfirm_dialog_cancel_button'),
                                                    rightButtonText: Utils.getString(
                                                        context,
                                                        'basket_list__comfirm_dialog_ok_button'),
                                                    onAgreeTap: () async {
                                                      await basketProvider
                                                        .deleteWholeBasketList();

                                                      await basketProvider.addBasket(basket!);
                                                      
                                                      Fluttertoast.showToast(
                                                        msg:
                                                          Utils.getString(context, 'product_detail__success_add_to_basket'),
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: PsColors.mainColor,
                                                        textColor: PsColors.white);

                                                        await Navigator.pushNamed(
                                                          context,
                                                          RoutePaths.basketList,
                                                      );
                                                    });         
                                                }); 
                                            } else {
                                              await basketProvider.addBasket(basket!);
                                                  
                                              Fluttertoast.showToast(
                                                msg:
                                                  Utils.getString(context, 'product_detail__success_add_to_basket'),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: PsColors.mainColor,
                                                textColor: PsColors.white);

                                                await Navigator.pushNamed(
                                                  context,
                                                  RoutePaths.basketList,
                                              );
                                            }
                                          }
                                        } else {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarningDialog(
                                                  message: Utils.getString(context,
                                                      'product_detail__is_not_available'),
                                                  onPressed: () {},
                                          );
                                        });
                                      }
                                    },
                              );
                            }
                          })),
                  const SizedBox(height: PsDimens.space8),
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - widget.animation.value), 0.0),
                  child: child,
                ));
          });
    }));
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
            top: PsDimens.space28,
            left: PsDimens.space20,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: PsColors.textPrimaryDarkColor)),
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
