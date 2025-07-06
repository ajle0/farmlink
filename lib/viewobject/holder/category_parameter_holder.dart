import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    shopId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm = '';
  }

  String? orderBy;
  String? shopId;
  String? searchTerm;

  CategoryParameterHolder getTrendingParameterHolder() {
    shopId = '';
    orderBy = PsConst.FILTERING__TRENDING;
    searchTerm = '';
    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    shopId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm=  '';
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['shop_id'] = shopId;
    map['order_by'] = orderBy;
    map['searchterm'] = searchTerm;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    shopId = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm = dynamicData['searchterm'];
    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (shopId != '') {
      result += '${shopId!}:';
    }
    if (orderBy != '') {
      result += '${orderBy!}:';
    }

    return result;
  }
}
