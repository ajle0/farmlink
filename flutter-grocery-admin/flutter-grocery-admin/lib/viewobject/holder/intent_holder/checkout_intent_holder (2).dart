import 'package:flutter/cupertino.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.basketList,
    this.shopInfoProvider,
  });
  final List<Basket>? basketList;
  final ShopInfoProvider ?shopInfoProvider;
}
