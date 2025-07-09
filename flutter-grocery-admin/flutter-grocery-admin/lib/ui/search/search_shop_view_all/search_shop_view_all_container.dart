import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/provider/shop/shop_provider.dart';
import 'package:fluttermultigrocery/repository/shop_repository.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/shop_parameter_holder.dart';
import 'package:provider/provider.dart';
import '../../../config/ps_colors.dart';
import '../../../config/ps_config.dart';
import '../../../constant/ps_dimens.dart';
import '../../../constant/route_paths.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import '../../common/ps_ui_widget.dart';
import '../../shop_list/item/shop_verticle_list_item.dart';

class SearchShopViewAllContainer extends StatefulWidget {
  const SearchShopViewAllContainer({super.key, 
    required this.appBarTitle,
    required this.keyword,
  });
  final String appBarTitle;
  final String keyword;
  @override
  _SearchShopViewAllContainerState createState() =>
      _SearchShopViewAllContainerState();
}

final ScrollController _scrollController = ScrollController();
Animation<double>? animation;
AnimationController? animationController;
ShopRepository ?shopRepository;
PsValueHolder? valueHolder;
ShopProvider? provider;
ShopParameterHolder? holder;

class _SearchShopViewAllContainerState extends State<SearchShopViewAllContainer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider!.nextShopListByKey(holder!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
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

  @override
  Widget build(BuildContext context) {
    shopRepository = Provider.of<ShopRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context)),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
        ),
        body: ChangeNotifierProvider<ShopProvider>(
          lazy: false,
          create: (BuildContext context) {
            holder = ShopParameterHolder();
            holder!.searchTerm = widget.keyword;

            provider =
                ShopProvider(repo: shopRepository, psValueHolder: valueHolder);
            provider!.loadShopListByKey(holder!);
            return provider!;
          },
          child: Consumer<ShopProvider>(
              builder: (BuildContext context, ShopProvider provider, _) {
            if (
                provider.shop.data != null) {
              return Stack(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16,
                          right: PsDimens.space16,
                          top: PsDimens.space8,
                          bottom: PsDimens.space8),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return provider.resetShopList(holder!);
                        },
                        child: CustomScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count = provider.shop.data!.length;
                                    return ShopVerticleListItem(
                                      animationController: animationController!,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      shop: provider.shop.data![index],
                                      onTap: () {
                                        // final String loginUserId =
                                        //     Utils.checkUserLoginId(valueHolder);

                                        // final TouchCountParameterHolder
                                        //     touchCountParameterHolder =
                                        //     TouchCountParameterHolder(
                                        //         typeId:
                                        //             provider.shop.data[index].id,
                                        //         typeName: PsConst
                                        //             .FILTERING_TYPE_NAME_SHOP,
                                        //         userId: loginUserId,
                                        //         shopId:
                                        //             provider.shop.data[index].id);
                                        // provider.postTouchCount(
                                        //     touchCountParameterHolder.toMap());

                                        // provider.replaceShop(
                                        //     provider.shop.data[index].id,
                                        //     provider.shop.data[index].name);
                                        Navigator.pushNamed(
                                            context, RoutePaths.shop_dashboard,
                                            arguments: ShopDataIntentHolder(
                                                shopId: provider
                                                    .shop.data![index].id,
                                                shopName: provider
                                                    .shop.data![index].name));
                                      },
                                    );
                                  },
                                  childCount: provider.shop.data!.length,
                                ),
                              ),
                            ]),
                      )),
                  PSProgressIndicator(provider.shop.status)
                ],
              );
            } else {
              return Container();
            }
          }),
        ),
      ),
    );
  }
}
