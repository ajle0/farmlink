import 'package:flutter/material.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/productcollection/product_collection_provider.dart';
import 'package:fluttermultigrocery/repository/product_collection_repository.dart';
import 'package:fluttermultigrocery/ui/collection/item/collection_header_list_item.dart';

import 'package:fluttermultigrocery/ui/common/ps_ui_widget.dart';
import 'package:fluttermultigrocery/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';

import 'package:provider/provider.dart';

class CollectionHeaderListView extends StatefulWidget {
  const CollectionHeaderListView(
      {super.key, required this.animationController, required this.shopId});
  final AnimationController animationController;
  final String shopId;
  @override
  State<StatefulWidget> createState() => _CollectionHeaderListItem();
}

class _CollectionHeaderListItem extends State<CollectionHeaderListView> {
  final ScrollController _scrollController = ScrollController();
  ProductCollectionProvider? _productCollectionProvider;
  ProductCollectionRepository? productCollectionRepository;
  PsValueHolder ?psValueHolder;
  dynamic data;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _productCollectionProvider!.nextProductCollectionList();
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

  @override
  Widget build(BuildContext context) {
    productCollectionRepository =
        Provider.of<ProductCollectionRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

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

    return ChangeNotifierProvider<ProductCollectionProvider>(
      lazy: false,
      create: (BuildContext context) {
        final ProductCollectionProvider provider =
            ProductCollectionProvider(
              repo: productCollectionRepository,
              psValueHolder: psValueHolder);
        provider.loadProductCollectionList();
        _productCollectionProvider = provider;
        return _productCollectionProvider!;
      },
      child: Consumer<ProductCollectionProvider>(builder: (BuildContext context,
          ProductCollectionProvider provider, Widget? child) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: RefreshIndicator(
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: provider.productCollectionList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (provider.productCollectionList.data != null ||
                                provider.productCollectionList.data!.isEmpty) {
                              final int count =
                                  provider.productCollectionList.data!.length;
                              return CollectionHeaderListItem(
                                animationController: widget.animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                productCollectionHeader:
                                    provider.productCollectionList.data![index],
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutePaths.productListByCollectionId,
                                      arguments: ProductListByCollectionIdView(
                                        productCollectionHeader: provider
                                            .productCollectionList.data![index],
                                        appBarTitle: provider
                                            .productCollectionList
                                            .data![index]
                                            .name!,
                                      ));
                                },
                              );
                            } else {
                              return Container();
                            }
                          }),
                      onRefresh: () {
                        return provider.resetProductCollectionList();
                      },
                    ),
                  ),
                  PSProgressIndicator(provider.productCollectionList.status)
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
