import 'package:flutter/foundation.dart';

class PaymentCallBackHolder {
  PaymentCallBackHolder({
    @required this.isCash,
    @required this.payment,
  });

  final String? payment;
  final bool ?isCash;
}
