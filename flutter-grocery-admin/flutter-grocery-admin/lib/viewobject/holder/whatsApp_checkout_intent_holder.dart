import 'package:flutter/cupertino.dart';
import 'package:fluttermultigrocery/viewobject/basket.dart';

class WhatsAppCheckoutIntentHolder {
  const WhatsAppCheckoutIntentHolder({
    @required this.basketList,
  });
  final List<Basket>? basketList;
}
