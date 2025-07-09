import 'package:flutter/cupertino.dart';

class BillingToIntentHolder {
  const BillingToIntentHolder({
    @required this.userEmail,
    @required this.userPhoneNo,
  });

  final String? userEmail;
  final String? userPhoneNo;
}
