import 'package:flutter/cupertino.dart';
import 'package:fluttermultigrocery/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultigrocery/provider/user/user_provider.dart';

class OrderTimeIntentHolder {
  const OrderTimeIntentHolder({
    @required this.userProvider,
    @required this.shopInfoProvider,
  });
  final UserProvider? userProvider;
  final ShopInfoProvider? shopInfoProvider;
}
