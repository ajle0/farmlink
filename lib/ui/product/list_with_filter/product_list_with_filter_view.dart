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
import 'package:fluttermultigrocery/ui/product/item/product_vertical_list_item.dart';
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

class ProductListWithFilterView extends StatefulWidget {
  const ProductListWithFilterView(
      {super.key,
      required this.productParameterHolder,
      required this.animationController,
      this.changeAppBarTitle});

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Function? changeAppBarTitle;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListWithFilterView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SearchProductProvider? _searchProductProvider;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchProductProvider!.nextProductListByKey(
            _searchProductProvider!.productParameterHolder!);
      }
      //setState(() {
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
    //});
  }

  final double _containerMaxHeight = 60;
  double? _offset, _delta = 0, _oldOffset = 0;
  ProductRepository? repo1;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  dynamic data;
  PsValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  Basket? basket;
  String? id;
  String? colorId = '';
  String? qty;
  String? colorValue;
  bool? checkAttribute;
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  BasketSelectedAddOn basketSelectedAddOn = BasketSelectedAddOn();
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
    // DEBUG PRINT: Product list filter params
    print('ProductListWithFilterView: Filtering for category ID: \'${widget.productParameterHolder.catId}\'');
    repo1 = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (valueHolder!.isShowAdmob != null &&
        valueHolder!.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again < Filter View >............................');
    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final SearchProductProvider provider =
                  SearchProductProvider(repo: repo1!,  psValueHolder: valueHolder);
              provider.loadProductListByKey(widget.productParameterHolder);
              _searchProductProvider = provider;
              _searchProductProvider!.productParameterHolder =
                  widget.productParameterHolder;
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
          // DEBUG PRINT: Loaded products count
          print('ProductListWithFilterView: Loaded products: \'${provider.productList.data?.length ?? 0}\'');
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: PsColors.coreBackgroundColor,
                  child: Stack(children: <Widget>[
                    if (provider.productList.data!.isNotEmpty &&
                        provider.productList.data != null)
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
                                physics: const AlwaysScrollableScrollPhysics(),
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
                                          final int count =
                                              provider.productList.data!.length;
                                          final Product product =
                                              provider.productList.data![index];
                                          return ProductVeticalListItem(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider.productList
                                                        .data![index].id!,
                                            animationController:
                                                widget.animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                    widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
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
                              return provider.resetLatestProductList(
                                  _searchProductProvider!
                                      .productParameterHolder!);
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
                    Positioned(
                      bottom: _offset,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space12,
                            top: PsDimens.space8,
                            right: PsDimens.space12,
                            bottom: PsDimens.space16),
                        child: SizedBox(
                            width: double.infinity,
                            height: _containerMaxHeight,
                            child: BottomNavigationImageAndText(
                              searchProductProvider: _searchProductProvider!,
                              changeAppBarTitle: widget.changeAppBarTitle,
                            )),
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
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {super.key, this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider? searchProductProvider;
  final Function? changeAppBarTitle;

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
                  widget.changeAppBarTitle!(result[PsConst.CATEGORY_NAME]);
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
