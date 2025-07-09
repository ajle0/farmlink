import 'package:fluttermultigrocery/viewobject/common/ps_object.dart';

class DefaultLanguage extends PsObject<DefaultLanguage> {
  DefaultLanguage({
    this.languageCode,
    this.countryCode,
    this.name,
   
  });
  String? languageCode;
  String? countryCode;
  String? name;

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  DefaultLanguage fromMap(dynamic dynamicData) {
    //if (dynamicData != null) {
      return DefaultLanguage(
        languageCode: dynamicData['language_code'],
        countryCode: dynamicData['country_code'],
        name: dynamicData['name'],
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['language_code'] = object.languageCode;
      data['country_code'] = object.countryCode;
      data['name'] = object.name;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DefaultLanguage> fromMapList(List<dynamic> dynamicDataList) {
    final List<DefaultLanguage> branchlist = <DefaultLanguage>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          branchlist.add(fromMap(dynamicData));
        }
      }
    //}
    return branchlist;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>>[];
   // if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    //}
    return dynamicList;
  }
}
