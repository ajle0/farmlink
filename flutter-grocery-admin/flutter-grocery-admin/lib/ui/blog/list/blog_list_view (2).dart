import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/blog/blog_provider.dart';
import 'package:fluttermultigrocery/repository/blog_repository.dart';
import 'package:fluttermultigrocery/ui/blog/item/blog_list_item.dart';
import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';

import 'package:provider/provider.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  BlogProvider? _blogProvider;
  Animation<double>? animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _blogProvider!.nextBlogList();
      }
    });

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

  BlogRepository? repo1;
  PsValueHolder? psValueHolder;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<BlogRepository>(context);

    psValueHolder =
      Provider.of<PsValueHolder>(context, listen: false);

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
    return ChangeNotifierProvider<BlogProvider>(
      lazy: false,
      create: (BuildContext context) {
        final BlogProvider provider = BlogProvider(repo: repo1!, psValueHolder: psValueHolder);
        provider.loadBlogList();
        _blogProvider = provider;
        return _blogProvider!;
      },
      child: Consumer<BlogProvider>(
        builder: (BuildContext context, BlogProvider provider, Widget? child) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: Stack(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16,
                          right: PsDimens.space16,
                          top: PsDimens.space8,
                          bottom: PsDimens.space8),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.blogList.data != null ||
                                        provider.blogList.data!.isNotEmpty) {
                                      final int count =
                                          provider.blogList.data!.length;
                                      return BlogListItem(
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
                                        blog: provider.blogList.data![index],
                                        onTap: () {
                                          print(provider.blogList.data![index]
                                              .defaultPhoto!.imgPath);
                                          Navigator.pushNamed(
                                              context, RoutePaths.blogDetail,
                                              arguments: provider
                                                  .blogList.data![index]);
                                        },
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount: provider.blogList.data!.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetBlogList();
                        },
                      )),
                  PSProgressIndicator(provider.blogList.status)
                ],
              ))
            ],
          );
        },
      ),
    );
  }
}
