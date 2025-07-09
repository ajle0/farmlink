import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/repository/sub_category_repository.dart';
import 'package:fluttermultigrocery/ui/search/search_item_view_all/search_item_view_all_container.dart';
import 'package:fluttermultigrocery/viewobject/holder/sub_category_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/sub_category.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../api/common/ps_status.dart';
import '../../../config/ps_colors.dart';
import '../../../config/ps_config.dart';
import '../../../constant/ps_constants.dart';
import '../../../constant/route_paths.dart';
import '../../../provider/subcategory/search_sub_category_provider.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/holder/intent_holder/product_list_intent_holder.dart';
import '../../../viewobject/holder/product_parameter_holder.dart';
import '../../common/ps_ui_widget.dart';
import '../../subcategory/item/sub_category_grid_item.dart';
import '../../subcategory/list/sub_category_grid_view.dart';

class SearchSubCategoryViewAll extends StatefulWidget {
  const SearchSubCategoryViewAll({super.key, 
    required this.keyword,
  });
  final String keyword;
  @override
  _SearchSubCategoryViewAllState createState() =>
      _SearchSubCategoryViewAllState();
}

final ScrollController _scrollController = ScrollController();
AnimationController? animationController;
Animation<double>? animation;
SubCategoryRepository? subCategoryRepository;
SearchSubCategoryProvider? provider;
SubCategoryParameterHolder? holder;
bool isShowAdmob = true;

class _SearchSubCategoryViewAllState extends State<SearchSubCategoryViewAll>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        holder!.searchTerm = widget.keyword;
        provider!.loadNextSubCategoryList(holder!);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  bool isConnectedToInternet = false;
  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && isShowAdmob) {
        setState(() {});
      }
    });
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
    subCategoryRepository = Provider.of<SubCategoryRepository>(context);
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

    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<SearchSubCategoryProvider>(
            create: (BuildContext context) {
          provider = SearchSubCategoryProvider(
              repo: subCategoryRepository, valueHolder: psValueHolder);
          holder = SubCategoryParameterHolder();
          holder!.searchTerm = widget.keyword;
          provider!.loadSubCategoryListByKey(holder!);
          return provider!;
        }, child: Consumer<SearchSubCategoryProvider>(builder:
                (_, SearchSubCategoryProvider searchSubCategoryProvider, __) {
          if (
              searchSubCategoryProvider.subCategoryList.data != null ) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        child: RefreshIndicator(
                      onRefresh: () {
                        return provider!.resetSubCategoryList(
                          holder!,
                        );
                      },
                      child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 240,
                                      childAspectRatio: 1.4),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final List<SubCategory> subCategoryList =
                                      searchSubCategoryProvider
                                          .subCategoryList.data!;
                                  if (searchSubCategoryProvider
                                          .subCategoryList.status ==
                                      PsStatus.BLOCK_LOADING) {
                                    return Shimmer.fromColors(
                                        baseColor: PsColors.grey,
                                        highlightColor: PsColors.white,
                                        child: Column(children: const <Widget>[
                                          FrameUIForLoading(),
                                          FrameUIForLoading(),
                                          FrameUIForLoading(),
                                          FrameUIForLoading(),
                                          FrameUIForLoading(),
                                          FrameUIForLoading(),
                                        ]));
                                  } else {
                                    final int count = subCategoryList.length;
                                    return SubCategoryGridItem(
                                      subCategory: subCategoryList[index],
                                      onTap: () {
                                        final ProductParameterHolder
                                            productParameterHolder =
                                            ProductParameterHolder()
                                                .getSubCategoryByCatIdParameterHolder();
                                        productParameterHolder.subCatId =
                                            searchSubCategoryProvider
                                                .subCategoryList.data![index].id;
                                        productParameterHolder.catId =
                                            searchSubCategoryProvider
                                                .subCategoryList
                                                .data![index]
                                                .catId;
                                        Navigator.pushNamed(context,
                                            RoutePaths.filterProductList,
                                            arguments: ProductListIntentHolder(
                                                appBarTitle:
                                                    subCategoryList[index].name,
                                                productParameterHolder:
                                                    productParameterHolder));
                                      },
                                      animationController: animationController!,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      )),
                                    );
                                  }
                                },
                                childCount: searchSubCategoryProvider
                                    .subCategoryList.data!.length,
                              ),
                            ),
                          ]),
                    )),
                    PSProgressIndicator(
                      searchSubCategoryProvider.subCategoryList.status,
                      message:
                          searchSubCategoryProvider.subCategoryList.message,
                    )
                  ]),
                )
              ],
            );
          } else {
            return Container();
          }
        })));
  }
}
