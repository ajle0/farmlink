import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/ui/checkout/one_page_checkout/one_page_checkout_view.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';


class OnePageCheckoutContainerView extends StatefulWidget {
   const OnePageCheckoutContainerView({
    super.key,
    required this.basketList,
    required this.shopInfoProvider,
  });

  final List<Basket>? basketList;
  final ShopInfoProvider? shopInfoProvider;

  @override
  _OnePageCheckoutContainerViewState createState() =>
      _OnePageCheckoutContainerViewState();
}

class _OnePageCheckoutContainerViewState extends State<OnePageCheckoutContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> requestPop() {
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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle (
            statusBarIconBrightness : Utils.getBrightnessForAppBar(context)
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            Utils.getString(context, 'checkout__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0,
        ),
        body: OnePageCheckoutView(
          basketList: widget.basketList!,
          shopInfoProvider: widget.shopInfoProvider!,
        ),
      ),
    );
  }
}
