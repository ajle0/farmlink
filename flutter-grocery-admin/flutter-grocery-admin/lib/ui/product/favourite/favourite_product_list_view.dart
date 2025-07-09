import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/basket/basket_provider.dart';
import 'package:fluttermultigrocery/provider/product/favourite_product_provider.dart';
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
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider? _favouriteProductProvider;


  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider!.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  ProductRepository? repo1;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  PsValueHolder ?psValueHolder;
  dynamic data;
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
    repo1 = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (psValueHolder!.isShowAdmob != null &&
        psValueHolder!.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
     return MultiProvider(
          providers: <SingleChildWidget>[
        ChangeNotifierProvider<FavouriteProductProvider>(
          lazy: false,
          create: (BuildContext context) {
            final FavouriteProductProvider provider =
                FavouriteProductProvider(repo: repo1, psValueHolder: psValueHolder);
            provider.loadFavouriteProductList();
            _favouriteProductProvider = provider;
            return _favouriteProductProvider!;
          }),
        ChangeNotifierProvider<BasketProvider>(
          lazy: false,
          create: (BuildContext context) {
            basketProvider = BasketProvider(
              repo: basketRepository,
              psValueHolder: psValueHolder);
            basketProvider!.loadBasketList();
            return basketProvider!;
          }),
        ],
        child: Consumer<FavouriteProductProvider>(
          builder: (BuildContext context, FavouriteProductProvider provider,
              Widget? child) {
            if (
              //provider.favouriteProductList != null &&
                provider.favouriteProductList.data != null &&
                provider.favouriteProductList.data!.isNotEmpty) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: PsDimens.space4,
                              right: PsDimens.space4,
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
                                        if (provider.favouriteProductList.data !=
                                                null ||
                                            provider.favouriteProductList.data!
                                                .isNotEmpty) {
                                          final int count = provider
                                              .favouriteProductList.data!.length;
                                          final Product product = provider
                                              .favouriteProductList
                                              .data![index];
                                          return ProductVeticalListItem(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider.favouriteProductList
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
                                                    curve: Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            product: provider
                                                .favouriteProductList.data![index],
                                            onTap: () async {
                                              final ProductDetailIntentHolder
                                                  holder =
                                                  ProductDetailIntentHolder(
                                                productId: product.id,
                                                heroTagImage:
                                                    provider.hashCode.toString() +
                                                        product.id! +
                                                        PsConst.HERO_TAG__IMAGE,
                                                heroTagTitle:
                                                    provider.hashCode.toString() +
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
                                                    PsConst.HERO_TAG__UNIT_PRICE,
                                              );

                                              await Navigator.pushNamed(context,
                                                  RoutePaths.productDetail,
                                                  arguments: holder);

                                              await provider
                                                  .resetFavouriteProductList();
                                            },
                                            onButtonTap: () async {
                                              id =
                                                '${product.id}$colorId${basketSelectedAddOn.getSelectedaddOnIdByHeaderId()}${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                              if (product.minimumOrder == '0') {
                                                product.minimumOrder = '1' ;
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
                                                basketSelectedAttributeList:
                                                    basketSelectedAttribute.getSelectedAttributeList(),
                                                basketSelectedAddOnList:
                                                    basketSelectedAddOn.getSelectedAddOnList());

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
                                                          product: provider
                                                                .favouriteProductList.data![index]);
                                                      });
                                                  } else { 
                                                    if (basketProvider!.basketList.data!
                                                          .isNotEmpty &&
                                                        product.shop!.id !=
                                                      basketProvider!.basketList.data![0]
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
                                                                  await basketProvider!
                                                                      .deleteWholeBasketList();

                                                                  await basketProvider!.addBasket(basket!);

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
                                                      await basketProvider!.addBasket(basket!);
                                                          
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
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount: provider
                                          .favouriteProductList.data!.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetFavouriteProductList();
                            },
                          )),
                      PSProgressIndicator(provider.favouriteProductList.status)
                    ]),
                  )
                ],
              );
            } else {
              widget.animationController.forward();
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: widget.animationController,
                      curve: const Interval(0.5 * 1, 1.0,
                          curve: Curves.fastOutSlowIn)));
              return AnimatedBuilder(
                animation: widget.animationController,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(bottom: PsDimens.space120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/empty_fav.png',
                          height: 150,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        Text(
                          Utils.getString(context, 'fav_list__empty_title'),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                        ),
                        const SizedBox(
                          height: PsDimens.space20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              PsDimens.space32, 0, PsDimens.space32, 0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                Utils.getString(context, 'fav_list__empty_desc'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(),
                                textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child,
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
