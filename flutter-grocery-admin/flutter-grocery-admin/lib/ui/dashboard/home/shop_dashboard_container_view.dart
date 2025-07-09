import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/user/user_provider.dart';
import 'package:fluttermultigrocery/repository/user_repository.dart';
import 'package:fluttermultigrocery/ui/dashboard/home/shop_dashboard_view.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/blog_intent_holder.dart';
import 'package:provider/provider.dart';

class ShopDashboardContainerView extends StatefulWidget {
  const ShopDashboardContainerView(
      {super.key, required this.shopId, required this.shopName});
  final String? shopId;
  final String? shopName;

  @override
  _CityShopDashboardContainerViewState createState() =>
      _CityShopDashboardContainerViewState();
}

class _CityShopDashboardContainerViewState
    extends State<ShopDashboardContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider? userProvider;
  UserRepository? userRepo;

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
    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
        onWillPop: requestPop,
        child: Scaffold(
            appBar: AppBar(
              //backgroundColor: PsColors.mainColor,
              systemOverlayStyle: SystemUiOverlayStyle (
                statusBarIconBrightness : Utils.getBrightnessForAppBar(context)
              ),
              iconTheme: Theme.of(context).iconTheme.copyWith(),
              title: Text(
                widget.shopName ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(FontAwesome5.book_open),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.blogList,
                        arguments: BlogIntentHolder(
                            noBlogListForShop: false, shopId: widget.shopId));
                  },
                )
              ],
            ),
            body: ShopDashboardView(
                shopId: widget.shopId ?? '', shopName: widget.shopName ?? '')));
  }
}
