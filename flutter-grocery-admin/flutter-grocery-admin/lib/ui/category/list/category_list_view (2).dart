import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/category/category_provider.dart';
import 'package:fluttermultigrocery/repository/category_repository.dart';
import 'package:fluttermultigrocery/ui/category/item/category_vertical_list_item.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/db/cateogry_dao.dart';

import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/category_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/touch_count_parameter_holder.dart';

import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider? _categoryProvider;
  final CategoryParameterHolder categoryParameterHolder =
      CategoryParameterHolder().getLatestParameterHolder();

  AnimationController? animationController;
  Animation<double> ?animation;

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
        _categoryProvider!.nextCategoryList(categoryParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository? repo1;
  PsValueHolder? psValueHolder;
  dynamic data;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  bool isShowSubCategory = false;
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

    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (psValueHolder?.isShowAdmob != null &&
        psValueHolder?.isShowAdmob == PsConst.ONE) {
        isShowAdmob = true;
    } else {
        isShowAdmob = false;
    }
    if (!isConnectedToInternet && isShowAdmob) {
      print('loading ads....');
      checkConnection();
    }

    if (psValueHolder?.isShowSubCategory != null &&
        psValueHolder?.isShowSubCategory == PsConst.ONE) {
        isShowSubCategory = true;
    } else {
        isShowSubCategory = false;
    }
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: requestPop,
        child: ChangeNotifierProvider<CategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              try {
                // Add defensive checks for null values
                final CategoryRepository safeRepo = repo1 ?? CategoryRepository(
                  psApiService: Provider.of<PsApiService>(context, listen: false),
                  categoryDao: Provider.of<CategoryDao>(context, listen: false)
                );
                
                final PsValueHolder safeValueHolder = psValueHolder ?? Provider.of<PsValueHolder>(context, listen: false);
                final int safeLimit = safeValueHolder.categoryLoadingLimit ?? 10; // Default limit
                
                final CategoryProvider provider = CategoryProvider(
                  repo: safeRepo, 
                  psValueHolder: safeValueHolder,
                  limit: safeLimit
                );
              provider.loadCategoryList(categoryParameterHolder);
              _categoryProvider = provider;
              return _categoryProvider!;
              } catch (e, stack) {
                debugPrint('Error creating CategoryProvider: '
                    'Error: $e'
                    'Stack: $stack');
                // Return a dummy provider with empty data to avoid crash
                final CategoryProvider dummyProvider = CategoryProvider(
                  repo: repo1 ?? CategoryRepository(
                    psApiService: Provider.of<PsApiService>(context, listen: false),
                    categoryDao: Provider.of<CategoryDao>(context, listen: false)),
                  psValueHolder: psValueHolder ?? Provider.of<PsValueHolder>(context, listen: false),
                  limit: 10,
                );
                return dummyProvider;
              }
            },
            child: Consumer<CategoryProvider>(builder: (BuildContext context,
                CategoryProvider provider, Widget? child) {
              return Stack(children: <Widget>[
                Column(children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
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
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.categoryList.data != null &&
                                          provider.categoryList.data!.isNotEmpty) {
                                        final int count =
                                            provider.categoryList.data!.length;
                                        if (index < count) {
                                        return CategoryVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController!,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          category:
                                              provider.categoryList.data![index],
                                          onTap: () {
                                            if (isShowSubCategory) {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.subCategoryGrid,
                                                  arguments: provider
                                                      .categoryList
                                                      .data![index]);
                                            } else {
                                              final String loginUserId =
                                                  Utils.checkUserLoginId(
                                                        psValueHolder ?? Provider.of<PsValueHolder>(context, listen: false));
                                              final TouchCountParameterHolder
                                                  touchCountParameterHolder =
                                                  TouchCountParameterHolder(
                                                      typeId: provider
                                                          .categoryList
                                                          .data![index]
                                                          .id,
                                                      typeName: PsConst
                                                          .FILTERING_TYPE_NAME_CATEGORY,
                                                      userId: loginUserId,
                                                      shopId: '');

                                              provider.postTouchCount(
                                                  touchCountParameterHolder
                                                      .toMap());
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder.catId =
                                                  provider.categoryList
                                                      .data![index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .categoryList
                                                        .data![index]
                                                        .name,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                            }
                                          },
                                        );
                                        } else {
                                          return null;
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.categoryList.data != null && provider.categoryList.data!.isNotEmpty ? provider.categoryList.data!.length : 0,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider
                                .resetCategoryList(categoryParameterHolder);
                          },
                        )),
                  ),
                ]),
                PSProgressIndicator(provider.categoryList.status)
              ]);
            })));
  }
}
