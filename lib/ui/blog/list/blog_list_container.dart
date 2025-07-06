import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/ui/blog/list/blog_list_view.dart';
import 'package:fluttermultigrocery/ui/blog/list/blog_list_view_shop.dart';
import 'package:fluttermultigrocery/utils/utils.dart';

class BlogListContainerView extends StatefulWidget {
  const BlogListContainerView({super.key, required this.noBlogListForShop, this.shopId});

  final bool? noBlogListForShop;
  final String? shopId;

  @override
  _BlogListContainerViewState createState() => _BlogListContainerViewState();
}

class _BlogListContainerViewState extends State<BlogListContainerView>
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
            title: Text(Utils.getString(context, 'blog_list__app_bar_name'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith()),
            elevation: 0,
          ),
          body: widget.noBlogListForShop!
              ? Container(
                  color: PsColors.coreBackgroundColor,
                  height: double.infinity,
                  child: BlogListView(
                    animationController: animationController!,
                  ),
                )
              : Container(
                  color: PsColors.coreBackgroundColor,
                  height: double.infinity,
                  child: BlogListViewShop(
                    animationController: animationController!,
                    shopId: widget.shopId!,
                  ),
                )),
    );
  }
}
