import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/basket/basket_provider.dart';
import 'package:fluttermultigrocery/provider/product/search_product_provider.dart';
import 'package:fluttermultigrocery/repository/basket_repository.dart';
import 'package:fluttermultigrocery/repository/product_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/choose_attribute_dialog.dart';
import 'package:fluttermultigrocery/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/product/item/product_vertical_list_item_for_home.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';
import 'package:fluttermultigrocery/viewobject/basket_selected_add_on.dart';
import 'package:fluttermultigrocery/viewobject/basket_selected_attribute.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProductListView extends StatefulWidget {
  const ProductListView(
      {super.key,
      required this.catId,
      required this.shopId,
      required this.flag,
      required this.isFeaturedItem});

  final String catId;
  final String shopId;
  final bool flag;
  final bool isFeaturedItem;

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  SearchProductProvider? _searchProductProvider;
  bool isVisible = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchProductProvider!.nextProductListByKey(holder!);
      }
      setState(() {
        final double offset = _scrollController.offset;
        _delta = offset - _oldOffset!;
        if (_delta! > _containerMaxHeight) {
          _delta = _containerMaxHeight;
        } else if (_delta! < 0) {
          _delta = 0;
        }
        _oldOffset = offset;
        _offset = -_delta!;
      });

      print(' Offset $_offset');
    });
  }

  final double _containerMaxHeight = 60;
  double? _offset, _delta = 0, _oldOffset = 0;
  ProductRepository? repo1;
  dynamic data;
  PsValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  String? cache;
  ProductParameterHolder? holder;
  Basket? basket;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  String? id;
  String colorId = '';
  String? qty;
  String? colorValue;
  bool? checkAttribute;
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  BasketSelectedAddOn basketSelectedAddOn = BasketSelectedAddOn();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    repo1 = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    if (repo1 == null || valueHolder == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.shopId.isEmpty || widget.catId.isEmpty) {
      print('ERROR: shopId or catId is empty');
      return const Center(child: Text('Configuration error: missing shop or category.'));
    }

    print(
        '............................Build UI Again ............................');
    print('DEBUG: shopId: \'${widget.shopId}\', catId: \'${widget.catId}\', holder: \'$holder\'');
    
    // Create holder before the null check
    if (holder == null) {
      if (widget.isFeaturedItem) {
        holder = ProductParameterHolder().getFeaturedParameterHolder();
      } else {
        holder = ProductParameterHolder().getLatestParameterHolder();
      }

      if (widget.catId == PsConst.mainMenu) {
        holder!.catId = '';
        holder!.shopId = widget.shopId;
      } else if (widget.catId == PsConst.featuredItem) {
        holder!.catId = '';
        holder!.shopId = widget.shopId;
      } else {
        holder!.catId = widget.catId;
        holder!.shopId = widget.shopId;
      }
      print('DEBUG: Created holder with catId: ${holder!.catId}, shopId: ${holder!.shopId}');
    }

    if (holder == null) {
      print('ERROR: holder is still null after creation attempt');
      return const Center(child: Text('Configuration error: missing product parameter holder.'));
    }

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final SearchProductProvider provider = SearchProductProvider(
                  repo: repo1!, 
                  psValueHolder: valueHolder,
                  limit: valueHolder?.latestProductLoadingLimit ?? 10);

              // Use the already-created holder
              provider.productParameterHolder = holder;

              if (widget.flag) {
                provider.loadProductListByKeyFromDB(holder!);
                print('CALL FROM DB');
              } else {
                provider.loadProductListByKey(holder!);
                print('CALL FROM server');
              }
              cache = widget.catId;
              _searchProductProvider = provider;
              _searchProductProvider!.productParameterHolder =
                  provider.productParameterHolder;
              return _searchProductProvider!;
            },
          ),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                basketProvider = BasketProvider(
                  repo: basketRepository,
                  psValueHolder: valueHolder);
                basketProvider!.loadBasketList();
                return basketProvider!;
              }),
        ],
        child: Consumer<SearchProductProvider>(builder: (BuildContext context,
            SearchProductProvider provider, Widget? child) {
          return Column(
            children: <Widget>[
              //const PsAdMobBannerWidget(),
              Expanded(
                child: Container(
                  color: PsColors.coreBackgroundColor,
                  child: Stack(children: <Widget>[
                    if (provider.productList.data != null &&
                        provider.productList.data!.isNotEmpty)
                      Container(
                          color: PsColors.coreBackgroundColor,
                          margin: const EdgeInsets.only(
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              top: PsDimens.space4,
                              bottom: PsDimens.space4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220,
                                            childAspectRatio: 0.6),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.productList.data != null ||
                                            provider
                                                .productList.data!.isNotEmpty) {
                                          final Product product =
                                              provider.productList.data![index];
                                          return ProductVeticalListItemForHome(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider.productList
                                                        .data![index].id!,
                                            product: provider
                                                .productList.data![index],
                                            onTap: () {
                                              final ProductDetailIntentHolder
                                                  holder =
                                                  ProductDetailIntentHolder(
                                                productId: product.id,
                                                heroTagImage: provider.hashCode
                                                        .toString() +
                                                    product.id! +
                                                    PsConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                        .toString() +
                                                    product.id! +
                                                    PsConst.HERO_TAG__TITLE,
                                                heroTagOriginalPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id! +
                                                    PsConst
                                                        .HERO_TAG__ORIGINAL_PRICE,
                                                heroTagUnitPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id! +
                                                    PsConst
                                                        .HERO_TAG__UNIT_PRICE,
                                              );

                                              Navigator.pushNamed(context,
                                                  RoutePaths.productDetail,
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
                                                  qty: qty ??
                                                      product.minimumOrder,
                                                  shopId: product.shop!.id,
                                                  selectedColorId: colorId,
                                                  selectedColorValue:
                                                      colorValue,
                                                  basketPrice:
                                                      bottomSheetPrice == null
                                                          ? product.unitPrice
                                                          : bottomSheetPrice
                                                              .toString(),
                                                  basketOriginalPrice:
                                                      totalOriginalPrice == 0.0
                                                          ? product
                                                              .originalPrice
                                                          : totalOriginalPrice
                                                              .toString(),
                                                  selectedAttributeTotalPrice:
                                                      basketSelectedAttribute
                                                          .getTotalSelectedAttributePrice()
                                                          .toString(),
                                                  product: product,
                                                  basketSelectedAttributeList:
                                                      basketSelectedAttribute
                                                          .getSelectedAttributeList(),
                                                  basketSelectedAddOnList:
                                                      basketSelectedAddOn
                                                          .getSelectedAddOnList());

                                              if (product.isAvailable == '1') {
                                                if (product.addOnList!
                                                            .isNotEmpty &&
                                                        product.addOnList![0].id !=
                                                            '' ||
                                                    product.customizedHeaderList!
                                                            .isNotEmpty &&
                                                        product
                                                                .customizedHeaderList![
                                                                    0]
                                                                .id !=
                                                            '' &&
                                                        product
                                                                .customizedHeaderList![
                                                                    0]
                                                                .customizedDetail !=
                                                            null) {
                                                  showDialog<dynamic>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ChooseAttributeDialog(
                                                            product: provider
                                                                .productList
                                                                .data![index]);
                                                      });
                                                } else {
                                                  if (basketProvider!.basketList
                                                          .data!.isNotEmpty &&
                                                      product.shop!.id !=
                                                          basketProvider!
                                                              .basketList
                                                              .data![0]
                                                              .shopId) {
                                                    showDialog<dynamic>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ConfirmDialogView(
                                                              description: Utils
                                                                  .getString(context,
                                                                      'warning_dialog__change_shop'),
                                                              leftButtonText:
                                                                  Utils.getString(
                                                                      context,
                                                                      'basket_list__comfirm_dialog_cancel_button'),
                                                              rightButtonText:
                                                                  Utils.getString(
                                                                      context,
                                                                      'basket_list__comfirm_dialog_ok_button'),
                                                              onAgreeTap:
                                                                  () async {
                                                                await basketProvider!
                                                                    .deleteWholeBasketList();

                                                                await basketProvider!
                                                                    .addBasket(
                                                                        basket!);

                                                                Fluttertoast.showToast(
                                                                    msg: Utils.getString(
                                                                        context,
                                                                        'product_detail__success_add_to_basket'),
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity: ToastGravity
                                                                        .BOTTOM,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        PsColors
                                                                            .mainColor,
                                                                    textColor:
                                                                        PsColors
                                                                            .white);

                                                                await Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  RoutePaths
                                                                      .basketList,
                                                                );
                                                              });
                                                        });
                                                  } else {
                                                    await basketProvider!
                                                        .addBasket(basket!);

                                                    Fluttertoast.showToast(
                                                        msg: Utils.getString(
                                                            context,
                                                            'product_detail__success_add_to_basket'),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            PsColors.mainColor,
                                                        textColor:
                                                            PsColors.white);

                                                    await Navigator.pushNamed(
                                                      context,
                                                      RoutePaths.basketList,
                                                    );
                                                  }
                                                }
                                              } else {
                                                showDialog<dynamic>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return WarningDialog(
                                                        message: Utils.getString(
                                                            context,
                                                            'product_detail__is_not_available'),
                                                        onPressed: () {},
                                                      );
                                                    });
                                              }
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.productList.data!.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetLatestProductList(holder!);
                            },
                          ))
                    else if (provider.productList.status !=
                            PsStatus.PROGRESS_LOADING &&
                        provider.productList.status != PsStatus.BLOCK_LOADING &&
                        provider.productList.status != PsStatus.NOACTION)
                      Align(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_empty_item_grey_24.png',
                                height: 100,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: PsDimens.space32,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space20,
                                    right: PsDimens.space20),
                                child: Text(
                                  Utils.getString(
                                      context, 'procuct_list__no_result_data'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(),
                                ),
                              ),
                              const SizedBox(
                                height: PsDimens.space20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    PSProgressIndicator(provider.productList.status),
                  ]),
                ),
              )
            ],
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText({super.key, this.searchProductProvider});
  final SearchProductProvider? searchProductProvider;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    if (widget.searchProductProvider!.productParameterHolder!.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchProductProvider!.productParameterHolder!
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PsColors.mainLightShadowColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: FontAwesome.list_bullet,
                  color: isClickBaseLineList
                      ? PsColors.mainColor
                      : PsColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__category'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isClickBaseLineList
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor)),
              ],
            ),
            onTap: () async {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.CATEGORY_ID] =
                  widget.searchProductProvider!.productParameterHolder!.catId!;
              dataHolder[PsConst.SUB_CATEGORY_ID] =
                  widget.searchProductProvider!.productParameterHolder!.subCatId!;
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.filterExpantion,
                  arguments: dataHolder);

              if (result != null) {
                widget.searchProductProvider!.productParameterHolder!.catId =
                    result[PsConst.CATEGORY_ID];
                widget.searchProductProvider!.productParameterHolder!.subCatId =
                    result[PsConst.SUB_CATEGORY_ID];
                widget.searchProductProvider!.resetLatestProductList(
                    widget.searchProductProvider!.productParameterHolder!);

                if (result[PsConst.CATEGORY_ID] == '' &&
                    result[PsConst.SUB_CATEGORY_ID] == '') {
                  isClickBaseLineList = false;
                } else {
                  isClickBaseLineList = true;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? PsColors.mainColor
                      : PsColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments:
                      widget.searchProductProvider!.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider!.productParameterHolder = result;
                widget.searchProductProvider!.resetLatestProductList(
                    widget.searchProductProvider!.productParameterHolder!);

                if (widget.searchProductProvider!.productParameterHolder!
                    .isFiltered()) {
                  isClickBaseLineTune = true;
                } else {
                  isClickBaseLineTune = false;
                }
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: PsColors.mainColor,
                ),
                Text(Utils.getString(context, 'search__sort'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSort,
                  arguments:
                      widget.searchProductProvider!.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider!.productParameterHolder = result;
                widget.searchProductProvider!.resetLatestProductList(
                    widget.searchProductProvider!.productParameterHolder!);
              }
            },
          ),
        ],
      ),
    );
  }
}

class PsIconWithCheck extends StatelessWidget {
  const PsIconWithCheck({super.key, this.icon, this.color});
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? PsColors.grey);
  }
}
