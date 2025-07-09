import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/category/category_provider.dart';
import 'package:fluttermultigrocery/provider/category/trending_category_provider.dart';
import 'package:fluttermultigrocery/provider/product/search_product_provider.dart';
import 'package:fluttermultigrocery/provider/productcollection/product_collection_provider.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/repository/category_repository.dart';
import 'package:fluttermultigrocery/repository/product_collection_repository.dart';
import 'package:fluttermultigrocery/repository/product_repository.dart';
import 'package:fluttermultigrocery/repository/shop_info_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultigrocery/ui/common/dialog/rating_dialog/core.dart';
import 'package:fluttermultigrocery/ui/common/dialog/rating_dialog/style.dart';
import 'package:fluttermultigrocery/ui/dashboard/home/home_tabbar_slider.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/category.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/category_parameter_holder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fluttermultigrocery/viewobject/shop_info.dart';
import 'package:fluttermultigrocery/api/ps_api_service.dart';
import 'package:fluttermultigrocery/db/product_collection_header_dao.dart';
import 'package:fluttermultigrocery/db/cateogry_dao.dart';
import 'package:fluttermultigrocery/db/shop_info_dao.dart';

class MainSingleDashboardViewWidget extends StatefulWidget {
  const MainSingleDashboardViewWidget(
      this.animationController, this.context, this.shopId, this.shopName, {super.key});
  final String shopId;
  final String shopName;
  final AnimationController animationController;
  final BuildContext context;

  String get effectiveShopId => shopId.isNotEmpty ? shopId : 'shop33d0547b62c436bcf76fa29021d19a9b';

  @override
  _MainSingleDashboardViewWidgetState createState() =>
      _MainSingleDashboardViewWidgetState();
}

class _MainSingleDashboardViewWidgetState
    extends State<MainSingleDashboardViewWidget> {
  PsValueHolder? valueHolder;
  CategoryRepository? repo1;
  ProductRepository ?repo2;
  ProductCollectionRepository? repo3;
  ShopInfoRepository? shopInfoRepository;
  CategoryProvider ?_categoryProvider;
  ShopInfoProvider? provider;
  TrendingCategoryProvider? _trendingCategoryProvider;
  final int count = 8;
  final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();

  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 5,
      remindLaunches: 1);

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider!
          .loadCategoryList(_categoryProvider!.latestCategoryParameterHolder);
    }

    if (Platform.isAndroid) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
            message: Utils.getString(context, 'rating_popup_dialog_message'),
            ignoreNativeDialog: true,
            actionsBuilder: (BuildContext context, double? stars) {
              return <Widget>[
                TextButton(
                  child: Text(
                    Utils.getString(context, 'dialog__ok'),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // _rateMyApp.save().then((void v) => Navigator.pop(context));
                      Navigator.pop(context);
                      if (stars <= 3) {
                        // await _rateMyApp
                        //     .callEvent(RateMyAppEventType.laterButtonPressed);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'rating_confirm_message'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText:
                                    Utils.getString(context, 'dialog__ok'),
                                onAgreeTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.contactUs,
                                  );
                                },
                              );
                            });
                      } else if (stars >= 4) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ];
            },
            onDismissed: () =>
                _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 16.0),
            ),
            starRatingOptions: const StarRatingOptions(),
          );
        }
      });
    }
  }

  SearchProductProvider? searchProductProvider;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ShopInfoProvider>(
              lazy: false,
              create: (BuildContext context) {
                print('DEBUG: Using real shop ID: ${widget.effectiveShopId}');
                provider = ShopInfoProvider(
                    repo: shopInfoRepository,
                    psValueHolder: valueHolder,
                    ownerCode: 'HomeDashboardViewWidget');
                provider?.loadShopInfo(widget.effectiveShopId);
                return provider ?? ShopInfoProvider(
                  repo: ShopInfoRepository(
                    psApiService: Provider.of<PsApiService>(context, listen: false),
                    shopInfoDao: Provider.of<ShopInfoDao>(context, listen: false)
                  ),
                  psValueHolder: Provider.of<PsValueHolder>(context, listen: false),
                  ownerCode: 'HomeDashboardViewWidget'
                );
              }),
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                try {
                  // Add defensive checks for null values
                  final CategoryRepository safeRepo = repo1 ?? CategoryRepository(
                    psApiService: Provider.of<PsApiService>(context, listen: false),
                    categoryDao: Provider.of<CategoryDao>(context, listen: false)
                  );
                  
                  final PsValueHolder safeValueHolder = valueHolder ?? Provider.of<PsValueHolder>(context, listen: false);
                  final int safeLimit = safeValueHolder.categoryLoadingLimit ?? 10; // Default limit
                  
                _categoryProvider ??= CategoryProvider(
                      repo: safeRepo,
                      psValueHolder: safeValueHolder,
                      limit: safeLimit);
                _categoryProvider!
                    .loadCategoryList(
                        _categoryProvider!.latestCategoryParameterHolder)
                    .then((dynamic value) {
                    final bool isConnectedToIntenet = value ?? false;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _categoryProvider!;
                } catch (e, stack) {
                  debugPrint('Error creating CategoryProvider: '
                      '\nError: $e'
                      '\nStack: $stack');
                  // Return a dummy provider with empty data to avoid crash
                  final CategoryProvider dummyProvider = CategoryProvider(
                    repo: repo1 ?? CategoryRepository(
                      psApiService: Provider.of<PsApiService>(context, listen: false),
                      categoryDao: Provider.of<CategoryDao>(context, listen: false)),
                    psValueHolder: valueHolder ?? Provider.of<PsValueHolder>(context, listen: false),
                    limit: 10,
                  );
                  return dummyProvider;
                }
              }),
          ChangeNotifierProvider<TrendingCategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                try {
                  // Add defensive checks for null values
                  final CategoryRepository safeRepo = repo1 ?? CategoryRepository(
                    psApiService: Provider.of<PsApiService>(context, listen: false),
                    categoryDao: Provider.of<CategoryDao>(context, listen: false)
                  );
                  
                  final PsValueHolder safeValueHolder = valueHolder ?? Provider.of<PsValueHolder>(context, listen: false);
                  final int safeLimit = safeValueHolder.categoryLoadingLimit ?? 10; // Default limit
                  
                  final TrendingCategoryProvider provider = TrendingCategoryProvider(
                      repo: safeRepo,
                      psValueHolder: safeValueHolder,
                      limit: safeLimit);
                provider
                    .loadTrendingCategoryList(trendingCategory.toMap())
                    .then((dynamic value) {
                    final bool isConnectedToIntenet = value ?? false;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return provider;
                } catch (e, stack) {
                  debugPrint('Error creating TrendingCategoryProvider: '
                      '\nError: $e'
                      '\nStack: $stack');
                  // Return a dummy provider with empty data to avoid crash
                  final TrendingCategoryProvider dummyProvider = TrendingCategoryProvider(
                    repo: repo1 ?? CategoryRepository(
                      psApiService: Provider.of<PsApiService>(context, listen: false),
                      categoryDao: Provider.of<CategoryDao>(context, listen: false)),
                    psValueHolder: valueHolder ?? Provider.of<PsValueHolder>(context, listen: false),
                    limit: 10,
                  );
                  return dummyProvider;
                }
              }),
          ChangeNotifierProvider<ProductCollectionProvider>(
              lazy: false,
              create: (BuildContext context) {
                print('DEBUG: Creating ProductCollectionProvider...');
                try {
                  // Add defensive checks for null values
                  final ProductCollectionRepository safeRepo = repo3 ?? ProductCollectionRepository(
                    psApiService: Provider.of<PsApiService>(context, listen: false),
                    productCollectionDao: Provider.of<ProductCollectionDao>(context, listen: false)
                  );
                  
                  final PsValueHolder safeValueHolder = valueHolder ?? Provider.of<PsValueHolder>(context, listen: false);
                  final int safeLimit = safeValueHolder.collectionProductLoadingLimit ?? 10;
                  
                  print('DEBUG: ProductCollectionProvider created successfully');
                  final ProductCollectionProvider provider = ProductCollectionProvider(
                      repo: safeRepo,
                      psValueHolder: safeValueHolder,
                      limit: safeLimit);
                provider.loadProductCollectionList();
                return provider;
                } catch (e, stack) {
                  print('DEBUG: Error creating ProductCollectionProvider: $e');
                  debugPrint('Error creating ProductCollectionProvider: '
                      '\nError: $e'
                      '\nStack: $stack');
                  // Return a dummy provider with empty data to avoid crash
                  final ProductCollectionProvider dummyProvider = ProductCollectionProvider(
                    repo: ProductCollectionRepository(
                      psApiService: Provider.of<PsApiService>(context, listen: false),
                      productCollectionDao: Provider.of<ProductCollectionDao>(context, listen: false)),
                    psValueHolder: Provider.of<PsValueHolder>(context, listen: false),
                    limit: 10,
                  );
                  return dummyProvider;
                }
              }),
        ],
        child: Container(
          // color: PsColors.white,
          child:

              ///
              /// category List Widget
              ///
              RefreshIndicator(
            onRefresh: () async {
              final provider = _trendingCategoryProvider ?? TrendingCategoryProvider(
                repo: CategoryRepository(
                  psApiService: Provider.of<PsApiService>(context, listen: false),
                  categoryDao: Provider.of<CategoryDao>(context, listen: false)
                ),
                psValueHolder: Provider.of<PsValueHolder>(context, listen: false),
                limit: 10,
              );
              
              provider.resetTrendingCategoryList(trendingCategory.toMap());
              // Note: resetTrendingCategoryList returns void, so we don't await it
            },
            child: _HomeCategoryHorizontalListWidget(
              // provider: provider,
              psValueHolder: valueHolder ?? Provider.of<PsValueHolder>(context, listen: false),
              animationController: widget.animationController,
              userInputItemNameTextEditingController:
                  userInputItemNameTextEditingController,
              shopId: widget.effectiveShopId,
              shopName: widget.shopName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 2, 1.0,
                          curve: Curves.fastOutSlowIn))), //animation
            ),
          ),
        ));
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {required this.animationController,
      required this.animation,
      required this.psValueHolder,
      required this.userInputItemNameTextEditingController,
      required this.shopId,
      required this.shopName});

  // final ShopInfoProvider? provider;
  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController userInputItemNameTextEditingController;
  final String shopId;
  final String shopName;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

bool showMainMenu = true;
bool showSpecialCollections = true;

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.psValueHolder.showMainMenu != null &&
        widget.psValueHolder.showMainMenu == PsConst.ONE) {
          showMainMenu = true;
      } else {
          showMainMenu = false;
      }
    if (widget.psValueHolder.showSpecialCollections != null &&
        widget.psValueHolder.showSpecialCollections == PsConst.ONE) {
          showSpecialCollections = true;
      } else {
          showSpecialCollections = false;
      }
    
    final ShopInfoProvider shopInfoProvider =
        Provider.of<ShopInfoProvider>(context, listen: false);

    return Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget? child) {
        print('DEBUG: CategoryProvider status: ${categoryProvider.categoryList.status}');
        print('DEBUG: CategoryProvider data length: ${categoryProvider.categoryList.data?.length ?? 0}');
        print('DEBUG: ShopInfoProvider data: ${shopInfoProvider.shopInfo.data != null}');
        
        if (categoryProvider.categoryList.data == null ||
            categoryProvider.categoryList.data?.isEmpty == true) {
          print('DEBUG: Returning empty container - no category data available');
          return Container();
        }
        if (shopInfoProvider.shopInfo.data == null) {
          print('DEBUG: ShopInfo is null - show loading');
          return Center(child: CircularProgressIndicator());
        }

        final List<Category> tmpList =
            List<Category>.from(categoryProvider.categoryList.data ?? []);
        int i = 0;

        if (showMainMenu) {
          tmpList.insert(
              i,
              Category(
                  id: PsConst.mainMenu,
                  name: Utils.getString(context, 'dashboard__main_menu')));
          i++;
        }

        if (showSpecialCollections) {
          tmpList.insert(
              i,
              Category(
                  id: PsConst.specialCollection,
                  name: Utils.getString(
                      context, 'dashboard__special_collection')));
        }

        print('DEBUG: Passing shopId: ${widget.shopId}, shopName: ${widget.shopName}');
        print('DEBUG: Category list:');
        for (final cat in tmpList) {
          print('  - id: \'${cat.id}\', name: \'${cat.name}\'');
        }
        return AnimatedBuilder(
            animation: widget.animationController,
            child: HomeTabbarProductListView(
                shopInfo: shopInfoProvider.shopInfo.data!,
                //animationController: widget.animationController,
                categoryList: tmpList, //categoryProvider.categoryList.data,
                userInputItemNameTextEditingController:
                    widget.userInputItemNameTextEditingController,
                valueHolder: widget.psValueHolder,
                shopId: widget.shopId,
                shopName: widget.shopName,
                key: Key('${tmpList.length}')),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    required this.headerName,
    // this.productCollectionHeader,
    required this.viewAllClicked,
  });

  final String headerName;
  final Function? viewAllClicked;
  // final ProductCollectionHeader? productCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall?.copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}

// Set the real shop ID for Olara Farm
const String realShopId = 'shop33d0547b62c436bcf76fa29021d19a9b';
