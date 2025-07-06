import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/basket/basket_provider.dart';
import 'package:fluttermultigrocery/provider/product/search_result_provider.dart';
import 'package:fluttermultigrocery/provider/search_history/search_history_provider.dart';
import 'package:fluttermultigrocery/repository/basket_repository.dart';
import 'package:fluttermultigrocery/repository/search_history_repository.dart';
import 'package:fluttermultigrocery/repository/search_result_repository.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/shop_list/item/shop_horizontal_list_item.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/category.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:fluttermultigrocery/viewobject/search_history.dart';
import 'package:fluttermultigrocery/viewobject/shop.dart';
import 'package:fluttermultigrocery/viewobject/sub_category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../api/common/ps_status.dart';
import '../../repository/shop_repository.dart';
import '../../viewobject/basket.dart';
import '../../viewobject/basket_selected_add_on.dart';
import '../../viewobject/basket_selected_attribute.dart';
import '../../viewobject/holder/intent_holder/product_list_intent_holder.dart';
import '../../viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import '../common/dialog/choose_attribute_dialog.dart';
import '../common/dialog/confirm_dialog_view.dart';
import '../common/dialog/warning_dialog_view.dart';
import '../common/ps_frame_loading_widget.dart';
import '../common/smooth_star_rating_widget.dart';
import '../product/item/product_horizontal_list_item.dart';

class SearchItemListView extends StatefulWidget {
  const SearchItemListView({
    super.key,
    required this.productParameterHolder,
  });

  final ProductParameterHolder productParameterHolder;

  @override
  _SearchHistoryListViewState createState() => _SearchHistoryListViewState();
}

class _SearchHistoryListViewState extends State<SearchItemListView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? fadeAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController!);
    super.initState();
  }

  final TextEditingController inputSearchController = TextEditingController();
  PsValueHolder? psValueHolder;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<bool> _requestPop() {
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, true);
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  SearchHistoryProvider? searchHistoryProvider;
  SearchHistoryRepository ?searchHistoryRepository;
  ShopRepository? shopRepository;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  SearchResultRepository? searchResultRepository;
  bool isCallFirstTime = true;
  SearchHistory? searchHistory;

  @override
  Widget build(BuildContext context) {
    searchResultRepository = Provider.of<SearchResultRepository>(context);
    searchHistoryRepository = Provider.of<SearchHistoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    shopRepository = Provider.of<ShopRepository>(context);

    inputSearchController.text = widget.productParameterHolder.searchTerm!;
    print(inputSearchController);
    final Widget searchTextFieldWidget = InkWell(
      child: Container(
        height: 40,
        width: double.infinity,
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.mainDividerColor,
          borderRadius: BorderRadius.circular(PsDimens.space4),
          border: Border.all(color: PsColors.mainDividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space12, top: PsDimens.space10),
          child: Text(inputSearchController.text.trim(),
              style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        inputSearchController.clear();
      },
    );
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context)),
          titleSpacing: 0,
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: searchTextFieldWidget,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: PsDimens.space8),
              child: IconButton(
                icon: Icon(Icons.close, color: PsColors.mainColor, size: 26),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        body: MultiProvider(
            providers: <SingleChildWidget>[
              ///
              ///
              ///
              ChangeNotifierProvider<SearchResultProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final SearchResultProvider provider =
                      SearchResultProvider(searchResultRepository);
                  final Map<String, dynamic> searchHolderMap = <String, String>{
                    'searchterm': inputSearchController.text.trim()
                  };
                  provider.loadSearchResult(searchHolderMap);
                  return provider;
                },
              ),
              ChangeNotifierProvider<BasketProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    basketProvider = BasketProvider(
                        repo: basketRepository, psValueHolder: psValueHolder);
                    basketProvider!.loadBasketList();
                    return basketProvider!;
                  }),
              ChangeNotifierProvider<SearchHistoryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  searchHistoryProvider = SearchHistoryProvider(
                      repo: searchHistoryRepository,
                      psValueHolder: psValueHolder);
                  return searchHistoryProvider!;
                },
              )
            ],
            child: Consumer<SearchResultProvider>(builder:
                (BuildContext context, SearchResultProvider provider,
                    Widget? child) {
              if (
                  provider.searchResult.data != null) {
                final List<Category> categoriesList =
                    provider.searchResult.data!.categories!;
                final List<SubCategory> subCategoriesList =
                    provider.searchResult.data!.subCategories!;
                final List<Shop> shopList = provider.searchResult.data!.shops!;

                final List<Product> itemList =
                    provider.searchResult.data!.products!;
                if (isCallFirstTime) {
                  ///
                  /// Add to Search History
                  ///
                  searchHistory = SearchHistory(
                      searchTeam: inputSearchController.text.trim());
                  searchHistoryProvider!.addSearchHistoryList(searchHistory!);

                  isCallFirstTime = false;
                }
                return SingleChildScrollView(
                    child: Container(
                        color: PsColors.baseColor,
                        child: Column(
                          children: <Widget>[
                            CustomResultListTileView(
                              fadeAnimation: fadeAnimation!,
                              animationController: animationController!,
                              viewAllPressed: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.searchCategoryViewAll,
                                    arguments: <String, String>{
                                      'title': Utils.getString(
                                          context, 'search__categories'),
                                      'keyword':
                                          inputSearchController.text.trim(),
                                    });
                              },
                              title: Utils.getString(context, 'search__categories'),
                              dataList: categoriesList,
                            ),
                            CustomResultListTileView(
                              fadeAnimation: fadeAnimation!,
                              animationController: animationController!,
                              viewAllPressed: () {
                                Navigator.pushNamed(context,
                                    RoutePaths.searchSubCategoryViewAll,
                                    arguments: <String, String>{
                                      'title': Utils.getString(
                                          context, 'search__sub_categories'),
                                      'keyword':
                                          inputSearchController.text.trim(),
                                    });
                              },
                              title: Utils.getString(context, 'search__sub_categories'),
                              dataList: subCategoriesList,
                            ),
                            if (shopList.isNotEmpty )
                              ShopResultView(
                                animationController: animationController!,
                                inputSearchController: inputSearchController,
                                shopList: shopList,
                                fadeAnimation: fadeAnimation!,
                              )
                            else
                              Container(),
                            CustomItemResultListView(
                              fadeAnimation: fadeAnimation!,
                              animationController: animationController!,
                              productList: itemList,
                              provider: provider,
                              keyword: inputSearchController.text.trim(),
                            ),
                          ],
                        )));
              } else {
                return PSProgressIndicator(provider.searchResult.status);
              }
            })),
      ),
    );
  }
}

class ShopResultView extends StatelessWidget {
  const ShopResultView({
    super.key,
    required this.inputSearchController,
    required this.shopList,
    required this.animationController,
    required this.fadeAnimation,
  });

  final TextEditingController inputSearchController;
  final List<Shop> shopList;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedBuilder(
        animation: fadeAnimation,
        child: Container(
          color: PsColors.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  Utils.getString(context, 'search__shops'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 16,fontWeight: FontWeight.bold),
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.searchShopViewAll,
                      arguments: <String, String>{
                        'title': Utils.getString(context, 'search__shops'),
                        'keyword': inputSearchController.text.trim(),
                      });
                },
                child: Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 12.5, fontWeight: FontWeight.w600,color: PsColors.mainColor),
                ),
              ),
            ],
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
      Container(
          height: PsDimens.space320,
          color: PsColors.baseColor,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: PsDimens.space16),
              itemCount: shopList.length,
              itemBuilder: (BuildContext context, int index) {
                animationController.forward();

                return AnimatedBuilder(
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / shopList.length) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / shopList.length) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            100 *
                                (1.0 -
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                          CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 / shopList.length) * index,
                                                1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        )
                                        .value),
                            0.0),
                        child: child,
                      ),
                    );
                  },
                  child: ShopHorizontalListItem(
                    shop: shopList[index],
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.shop_dashboard,
                          arguments: ShopDataIntentHolder(
                              shopId: shopList[index].id,
                              shopName: shopList[index].name));
                    },
                  ),
                );
              })),
      const SizedBox(height: PsDimens.space8),
    ]);
  }
}

class CustomItemResultListView extends StatefulWidget {
  const CustomItemResultListView({
    super.key,
    required this.productList,
    required this.provider,
    required this.keyword,
    required this.animationController,
    required this.fadeAnimation,
  });

  final List<Product> productList;
  final SearchResultProvider provider;
  final String keyword;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  @override
  State<CustomItemResultListView> createState() =>
      _CustomItemResultListViewState();
}

class _CustomItemResultListViewState extends State<CustomItemResultListView>
    with SingleTickerProviderStateMixin {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool ?checkAttribute;
  Basket? basket;
  String? id;
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  BasketSelectedAddOn basketSelectedAddOn = BasketSelectedAddOn();

  @override
  Widget build(BuildContext context) {
    final BasketProvider basketProvider = Provider.of<BasketProvider>(context);

    if (widget.productList.isNotEmpty ) {
      return Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: widget.fadeAnimation,
            child: Container(
              color: PsColors.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Text(
                      Utils.getString(context, 'search__items'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                  ),
                  RawMaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RoutePaths.searchItemViewAll,
                            arguments: <String, String>{
                              'title': 'Items',
                              'keyword': widget.keyword,
                            });
                      },
                      child: Text(
                        Utils.getString(context, 'dashboard__view_all'),
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontSize: 12.5, fontWeight: FontWeight.w600,color: PsColors.mainColor),
                      )),
                ],
              ),
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.fadeAnimation,
                child: child,
              );
            },
          ),
          GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.6, maxCrossAxisExtent: 220),
              itemCount: widget.productList.length,
              itemBuilder: (BuildContext context, int index) {
                widget.animationController.forward();
                if (widget.provider.searchResult.status ==
                    PsStatus.BLOCK_LOADING) {
                  return Shimmer.fromColors(
                      baseColor: PsColors.grey,
                      highlightColor: PsColors.white,
                      child: Row(children: const <Widget>[
                        PsFrameUIForLoading(),
                      ]));
                } else {
                  final Product product =
                      widget.provider.searchResult.data!.products![index];
                  return AnimatedBuilder(
                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval(
                            (1 / widget.productList.length) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval(
                                (1 / widget.productList.length) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        ),
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0,
                              100 *
                                  (1.0 -
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 /
                                                          widget.productList
                                                              .length) *
                                                      index,
                                                  1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          )
                                          .value),
                              0.0),
                          child: child,
                        ),
                      );
                    },
                    child: ProductHorizontalListItem(
                      coreTagKey:
                          widget.provider.hashCode.toString() + product.id!,
                      product:
                          widget.provider.searchResult.data!.products![index],
                      onTap: () {
                        final ProductDetailIntentHolder holder =
                            ProductDetailIntentHolder(
                          productId: product.id,
                          heroTagImage: widget.provider.hashCode.toString() +
                              product.id !+
                              PsConst.HERO_TAG__IMAGE,
                          heroTagTitle: widget.provider.hashCode.toString() +
                              product.id !+
                              PsConst.HERO_TAG__TITLE,
                          heroTagOriginalPrice:
                              widget.provider.hashCode.toString() +
                                  product.id!+
                                  PsConst.HERO_TAG__ORIGINAL_PRICE,
                          heroTagUnitPrice:
                              widget.provider.hashCode.toString() +
                                  product.id! +
                                  PsConst.HERO_TAG__UNIT_PRICE,
                        );
                        Navigator.pushNamed(context, RoutePaths.productDetail,
                            arguments: holder);
                      },
                      onButtonTap: () async {
                        id =
                            '${product.id}$colorId${basketSelectedAddOn.getSelectedaddOnIdByHeaderId()}${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                        if (product.minimumOrder == '0') {
                          product.minimumOrder = '1';
                        }
                        basket = Basket(
                            id: id,
                            productId: product.id,
                            qty: qty ?? product.minimumOrder,
                            shopId: product.shop!.id,
                            selectedColorId: colorId,
                            selectedColorValue: colorValue,
                            basketPrice: bottomSheetPrice == null
                                ? product.unitPrice
                                : bottomSheetPrice.toString(),
                            basketOriginalPrice: totalOriginalPrice == 0.0
                                ? product.originalPrice
                                : totalOriginalPrice.toString(),
                            selectedAttributeTotalPrice: basketSelectedAttribute
                                .getTotalSelectedAttributePrice()
                                .toString(),
                            product: product,
                            basketSelectedAttributeList: basketSelectedAttribute
                                .getSelectedAttributeList(),
                            basketSelectedAddOnList:
                                basketSelectedAddOn.getSelectedAddOnList());

                        if (product.isAvailable == '1') {
                          if (product.addOnList!.isNotEmpty &&
                                  product.addOnList![0].id != '' ||
                              product.customizedHeaderList!.isNotEmpty &&
                                  product.customizedHeaderList![0].id != '' &&
                                  product.customizedHeaderList![0]
                                          .customizedDetail !=
                                      null) {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ChooseAttributeDialog(
                                      product: widget.provider.searchResult.data!
                                          .products![index]);
                                });
                          } else {
                            if (basketProvider.basketList.data!.isNotEmpty &&
                                product.shop!.id !=
                                    basketProvider.basketList.data![0].shopId) {
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

                                          await basketProvider
                                              .addBasket(basket!);

                                          Fluttertoast.showToast(
                                              msg: Utils.getString(context,
                                                  'product_detail__success_add_to_basket'),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  PsColors.mainColor,
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
                                  msg: Utils.getString(context,
                                      'product_detail__success_add_to_basket'),
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
                    ),
                  );
                }
                // return AnimatedBuilder(
                //   animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                //     CurvedAnimation(
                //       parent: animationController,
                //       curve: Interval(
                //           (1 / widget.productList.length) * index, 1.0,
                //           curve: Curves.fastOutSlowIn),
                //     ),
                //   ),
                //   builder: (BuildContext context, Widget child) {
                //     return FadeTransition(
                //       opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                //         CurvedAnimation(
                //           parent: animationController,
                //           curve: Interval(
                //               (1 / widget.productList.length) * index, 1.0,
                //               curve: Curves.fastOutSlowIn),
                //         ),
                //       ),
                //       child: Transform(
                //         transform: Matrix4.translationValues(
                //             0.0,
                //             100 *
                //                 (1.0 -
                //                     Tween<double>(begin: 0.0, end: 1.0)
                //                         .animate(
                //                           CurvedAnimation(
                //                             parent: animationController,
                //                             curve: Interval(
                //                                 (1 /
                //                                         widget.productList
                //                                             .length) *
                //                                     index,
                //                                 1.0,
                //                                 curve: Curves.fastOutSlowIn),
                //                           ),
                //                         )
                //                         .value),
                //             0.0),
                //         child: child,
                //       ),
                //     );
                //   },
                //   child: ProductHorizontalListItem(
                //     coreTagKey: widget.provider.hashCode.toString() +
                //         widget.productList[index].id,
                //     product: widget.productList[index],
                //     onTap: () {
                //       print(widget.productList[index].defaultPhoto.imgPath);
                //       final ProductDetailIntentHolder holder =
                //           ProductDetailIntentHolder(
                //         productId: widget.productList[index].id,
                //         heroTagImage: widget.provider.hashCode.toString() +
                //             widget.productList[index].id +
                //             PsConst.HERO_TAG__IMAGE,
                //         heroTagTitle: widget.provider.hashCode.toString() +
                //             widget.productList[index].id +
                //             PsConst.HERO_TAG__TITLE,
                //         heroTagOriginalPrice:
                //             widget.provider.hashCode.toString() +
                //                 widget.productList[index].id +
                //                 PsConst.HERO_TAG__ORIGINAL_PRICE,
                //         heroTagUnitPrice:
                //             widget.provider.hashCode.toString() +
                //                 widget.productList[index].id +
                //                 PsConst.HERO_TAG__UNIT_PRICE,
                //       );
                //       Navigator.pushNamed(context, RoutePaths.productDetail,
                //           arguments: holder);
                //     },
                //     onButtonTap: () async {
                //       if (widget.productList[index].isAvailable == '1') {
                //         if (widget.productList[index].addOnList.isNotEmpty &&
                //                 widget.productList[index].addOnList[0].id !=
                //                     '' ||
                //             widget.productList[index].customizedHeaderList
                //                     .isNotEmpty &&
                //                 widget.productList[index]
                //                         .customizedHeaderList[0].id !=
                //                     '' &&
                //                 widget
                //                         .productList[index]
                //                         .customizedHeaderList[0]
                //                         .customizedDetail !=
                //                     null) {
                //           showDialog<dynamic>(
                //               context: context,
                //               builder: (BuildContext context) {
                //                 return ChooseAttributeDialog(
                //                     product: widget.productList[index]);
                //               });
                //         } else {
                //           if (basketProvider.basketList.data.isNotEmpty &&
                //               widget.productList[index].shop.id !=
                //                   basketProvider.basketList.data[0].shopId) {
                //             showDialog<dynamic>(
                //                 context: context,
                //                 builder: (BuildContext context) {
                //                   return ConfirmDialogView(
                //                       description: Utils.getString(context,
                //                           'warning_dialog__change_shop'),
                //                       leftButtonText: Utils.getString(context,
                //                           'basket_list__comfirm_dialog_cancel_button'),
                //                       rightButtonText: Utils.getString(
                //                           context,
                //                           'basket_list__comfirm_dialog_ok_button'),
                //                       onAgreeTap: () async {
                //                         await basketProvider
                //                             .deleteWholeBasketList();

                //                         await basketProvider
                //                             .addBasket(basket);

                //                         Fluttertoast.showToast(
                //                             msg: Utils.getString(context,
                //                                 'product_detail__success_add_to_basket'),
                //                             toastLength: Toast.LENGTH_SHORT,
                //                             gravity: ToastGravity.BOTTOM,
                //                             timeInSecForIosWeb: 1,
                //                             backgroundColor:
                //                                 PsColors.mainColor,
                //                             textColor: PsColors.white);

                //                         await Navigator.pushNamed(
                //                           context,
                //                           RoutePaths.basketList,
                //                         );
                //                       });
                //                 });
                //           } else {
                //             await basketProvider.addBasket(basket);

                //             Fluttertoast.showToast(
                //                 msg: Utils.getString(context,
                //                     'product_detail__success_add_to_basket'),
                //                 toastLength: Toast.LENGTH_SHORT,
                //                 gravity: ToastGravity.BOTTOM,
                //                 timeInSecForIosWeb: 1,
                //                 backgroundColor: PsColors.mainColor,
                //                 textColor: PsColors.white);

                //             await Navigator.pushNamed(
                //               context,
                //               RoutePaths.basketList,
                //             );
                //           }
                //         }
                //       } else {
                //         showDialog<dynamic>(
                //             context: context,
                //             builder: (BuildContext context) {
                //               return WarningDialog(
                //                 message: Utils.getString(context,
                //                     'product_detail__is_not_available'),
                //                 onPressed: () {},
                //               );
                //             });
                //       }
                //     },
                // ),
                // );
              }),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class CustomShopResultListView extends StatelessWidget {
  const CustomShopResultListView({
    super.key,
    required this.shopList,
  });

  final List<Shop> shopList;

  dynamic getOpenAndCloseTime(BuildContext context, Shop shop) {
    final String days = DateFormat('EEEE').format(DateTime.now());
    print(days);
    if (days == 'Monday') {
      if (shop.shopSchedules!.mondayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.mondayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.mondayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Tuesday') {
      if (shop.shopSchedules!.tuesdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.tuesdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.tuesdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Wednesday') {
      if (shop.shopSchedules!.wednesdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.wednesdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.wednesdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Thursday') {
      if (shop.shopSchedules!.thursdayCloseHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.thursdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.thursdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Friday') {
      if (shop.shopSchedules!.fridayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.fridayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.fridayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Saturday') {
      if (shop.shopSchedules!.saturdayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.saturdayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.saturdayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    } else if (days == 'Sunday') {
      if (shop.shopSchedules!.sundayOpenHour != null) {
        return Text(
          '${Utils.getString(context, 'shop_open')} ${shop.shopSchedules!.sundayOpenHour} - ${Utils.getString(context, 'shop_close')}${shop.shopSchedules!.sundayCloseHour}',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          maxLines: 1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shopList.isNotEmpty ) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text('Shop'),
              ),
              Padding(
                padding: const  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(Utils.getString(context, 'dashboard__view_all')),
              ),
            ],
          ),
          SizedBox(
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            height: PsDimens.space180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: shopList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: PsDimens.space280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: PsDimens.space180 / 2,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: PsNetworkImage(
                              defaultPhoto: shopList[index].defaultPhoto!,
                              photoKey: '',
                              width: PsDimens.space280,
                              height: PsDimens.space180 / 2,
                              boxfit: BoxFit.cover,
                              onTap: () {},
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(shopList[index].name!),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: shopList[index].shopSchedules != null
                              ? getOpenAndCloseTime(context, shopList[index])
                              : const SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SmoothStarRating(
                                  key: Key(shopList[index]
                                      .ratingDetail!
                                      .totalRatingValue!),
                                  rating: double.parse(shopList[index]
                                      .ratingDetail!
                                      .totalRatingValue!),
                                  allowHalfRating: false,
                                  onRated: (double? v) {},
                                  starCount: 5,
                                  size: 20.0,
                                  color: PsColors.ratingColor,
                                  borderColor: PsColors.grey.withAlpha(100),
                                  spacing: 0.0),
                              Container(
                                child: GestureDetector(
                                    child: Icon(
                                      FontAwesome5.directions,
                                        size: 32, color: PsColors.mainColor),
                                    onTap: () async {
                                      if (Platform.isIOS) {
                                        await MapLauncher.showMarker(
                                          mapType: MapType.apple,
                                          coords: Coords(
                                              double.parse(shopList[index].lat!),
                                              double.parse(
                                                  shopList[index].lng!)),
                                          title: 'Shop on Map',
                                        );
                                      } else {
                                        await MapLauncher.showMarker(
                                          mapType: MapType.google,
                                          coords: Coords(
                                              double.parse(shopList[index].lat!),
                                              double.parse(
                                                  shopList[index].lng!)),
                                          title: 'Shop on Map',
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class CustomResultListTileView extends StatefulWidget {
  const CustomResultListTileView({
    super.key,
    required this.title,
    required this.dataList,
    required this.viewAllPressed,
    required this.animationController,
    required this.fadeAnimation,
  });
  final String title;
  final List<dynamic> dataList;
  final Function viewAllPressed;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  @override
  State<CustomResultListTileView> createState() =>
      _CustomResultListTileViewState();
}

class _CustomResultListTileViewState extends State<CustomResultListTileView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.dataList.isNotEmpty ) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        AnimatedBuilder(
          animation: widget.fadeAnimation,
          child: Container(
            color: PsColors.backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                ),
                RawMaterialButton(
                    onPressed: widget.viewAllPressed as void Function()?,
                    child: Text(
                      Utils.getString(context, 'dashboard__view_all'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 12.5, fontWeight: FontWeight.w600,color: PsColors.mainColor),
                    )),
              ],
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: widget.fadeAnimation,
              child: child,
            );
          },
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            itemCount: widget.dataList.length,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return AnimatedBuilder(
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / widget.dataList.length) * index, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval(
                            (1 / widget.dataList.length) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0,
                          100 *
                              (1.0 -
                                  Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / widget.dataList.length) *
                                                  index,
                                              1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      )
                                      .value),
                          0.0),
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    if (widget.dataList[index] is Category) {
                      Navigator.pushNamed(context, RoutePaths.subCategoryGrid,
                          arguments: widget.dataList[index]);
                    }

                    if (widget.dataList[index] is SubCategory) {
                      final ProductParameterHolder parameterHolder =
                          ProductParameterHolder()
                              .getSubCategoryByCatIdParameterHolder();
                      parameterHolder.subCatId = widget.dataList[index].id;
                      parameterHolder.catId = widget.dataList[index].catId;
                      final ProductListIntentHolder holder =
                          ProductListIntentHolder(
                              productParameterHolder: parameterHolder,
                              appBarTitle: widget.dataList[index].name);
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: holder);
                    }
                  },
                  child: Container(
                    height: 45,
                    color: PsColors.baseColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(widget.dataList[index].name),
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: PsColors.mainColor,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
      ]);
    } else {
      return const SizedBox();
    }
  }
}

// class SearchItemListViewWidget extends StatefulWidget {
//   const SearchItemListViewWidget({
//     Key key,
//     @required this.parameterHolder,
//     @required this.provider,
//     @required this.scrollController,
//     @required this.animationController,
//     @required this.animation,
//   }) : super(key: key);

//   final ProductParameterHolder parameterHolder;
//   final SearchProductProvider provider;
//   final ScrollController scrollController;
//   final AnimationController animationController;
//   final Animation<double> animation;

//   @override
//   _SearchItemListViewWidgetState createState() =>
//       _SearchItemListViewWidgetState();
// }

// class _SearchItemListViewWidgetState extends State<SearchItemListViewWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: <Widget>[
//       Container(
//           child: RefreshIndicator(
//         child: ListView.builder(
//             controller: widget.scrollController,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: widget.provider.productList.data.length,
//             itemBuilder: (BuildContext context, int index) {
//               final int count = widget.provider.productList.data.length;
//               final Product product = widget.provider.productList.data[index];
//               widget.animationController.forward();
//               return FadeTransition(
//                   opacity: widget.animation,
//                   child: SearchItemListItem(
//                     animationController: widget.animationController,
//                     animation: Tween<double>(begin: 0.0, end: 1.0).animate(
//                       CurvedAnimation(
//                         parent: widget.animationController,
//                         curve: Interval((1 / count) * index, 1.0,
//                             curve: Curves.fastOutSlowIn),
//                       ),
//                     ),
//                     product: widget.provider.productList.data[index],
//                     parameterHolder: widget.parameterHolder,
//                     onTap: () {
//                       final ProductDetailIntentHolder holder =
//                           ProductDetailIntentHolder(
//                         productId: product.id,
//                         heroTagImage: widget.provider.hashCode.toString() +
//                             product.id +
//                             PsConst.HERO_TAG__IMAGE,
//                         heroTagTitle: widget.provider.hashCode.toString() +
//                             product.id +
//                             PsConst.HERO_TAG__TITLE,
//                         heroTagOriginalPrice:
//                             widget.provider.hashCode.toString() +
//                                 product.id +
//                                 PsConst.HERO_TAG__ORIGINAL_PRICE,
//                         heroTagUnitPrice: widget.provider.hashCode.toString() +
//                             product.id +
//                             PsConst.HERO_TAG__UNIT_PRICE,
//                       );

//                       Navigator.pushNamed(context, RoutePaths.productDetail,
//                           arguments: holder);
//                     },
//                   ));
//             }),
//         onRefresh: () {
//           return widget.provider.resetLatestProductList(widget.parameterHolder);
//         },
//       )),
//       PSProgressIndicator(widget.provider.productList.status)
//     ]);
//   }
// }
