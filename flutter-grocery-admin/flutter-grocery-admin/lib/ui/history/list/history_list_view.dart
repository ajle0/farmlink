import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/history/history_provider.dart';
import 'package:fluttermultigrocery/repository/history_repsitory.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/history/item/history_list_item.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/product.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView>
    with SingleTickerProviderStateMixin {
  HistoryRepository? historyRepo;
  PsValueHolder? psValueHolder;
  dynamic data;

  @override
  void initState() {
    super.initState();
  }


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
    historyRepo = Provider.of<HistoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context, listen: false);

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
    return ChangeNotifierProvider<HistoryProvider>(
        lazy: false,
        create: (BuildContext context) {
          final HistoryProvider provider = HistoryProvider(
            repo: historyRepo!,
            psValueHolder: psValueHolder
          );
          provider.loadHistoryList();
          return provider;
        },
        child: Consumer<HistoryProvider>(
          builder:
              (BuildContext context, HistoryProvider provider, Widget? child) {
            if (
              //provider.historyList != null &&
                provider.historyList.data != null) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: PsDimens.space10),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count =
                                        provider.historyList.data!.length;
                                    return HistoryListItem(
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      history: provider
                                          .historyList.data!.reversed
                                          .toList()[index],
                                      onTap: () {
                                        final Product product = provider
                                            .historyList.data!.reversed
                                            .toList()[index];
                                        final ProductDetailIntentHolder holder =
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
                                              PsConst.HERO_TAG__ORIGINAL_PRICE,
                                          heroTagUnitPrice:
                                              provider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                        );

                                        Navigator.pushNamed(
                                            context, RoutePaths.productDetail,
                                            arguments: holder);
                                      },
                                    );
                                  },
                                  childCount: provider.historyList.data!.length,
                                ),
                              )
                            ]),
                        onRefresh: () {
                          return provider.resetHistoryList();
                        },
                      ),
                    ),
                  ),
                  PSProgressIndicator(provider.historyList.status),
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
