import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/ui/shop/branch/shop_branch_list_view.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';

class ShopBranchContainerView extends StatefulWidget {
  const ShopBranchContainerView({
    super.key,
    required this.shopId,
    required this.shopInfo,
  });

  final String? shopId;
  final ShopInfo? shopInfo;
  @override
  _ShopBranchContainerViewState createState() =>
      _ShopBranchContainerViewState();
}

class _ShopBranchContainerViewState extends State<ShopBranchContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
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
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(Utils.getString(context, 'shop_info__branch'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite)),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: ShopBranchListView(
            data: widget.shopInfo!,
            scrollController: _scrollController,
            shopId: widget.shopId ?? '',
          ),
        ),
      ),
    );
  }
}
