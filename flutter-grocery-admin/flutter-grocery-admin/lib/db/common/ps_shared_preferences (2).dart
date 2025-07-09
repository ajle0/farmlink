import 'dart:async';

import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PsSharedPreferences {
  PsSharedPreferences._() {
    Utils.psPrint('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }

 late Future<SharedPreferences> futureShared;
 late SharedPreferences shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences._();

  // Singleton accessor
  static PsSharedPreferences get instance => _singleton;

  final StreamController<PsValueHolder> _valueController =
      StreamController<PsValueHolder>();
  Stream<PsValueHolder> get psValueHolder => _valueController.stream;

  Future<dynamic> loadValueHolder() async {
    final String? loginUserId = shared.getString(PsConst.VALUE_HOLDER__USER_ID);
    final String? userIdToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String? userNameToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String? userEmailToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String? userPasswordToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String? notiToken =
        shared.getString(PsConst.VALUE_HOLDER__NOTI_TOKEN);
    final bool isToShowIntroSlider =
        shared.getBool(PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final bool? isUserAlradyChoose =
        shared.getBool(PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE);
    final bool ?notiSetting =
        shared.getBool(PsConst.VALUE_HOLDER__NOTI_SETTING);
    final String? overAllTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL);
    final String? overAllTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE);
    final String? shippingTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL);
    final String? shippingTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE);
    final String? minimumOrderAmount =
        shared.getString(PsConst.VALUE_HOLDER__MINIMUM_ORDER_AMOUNT);
    final String? shippingId =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_ID);
    final String? shopId = shared.getString(PsConst.VALUE_HOLDER__SHOP_ID);
    final String? messenger = shared.getString(PsConst.VALUE_HOLDER__MESSENGER);
    final String? whatsApp = shared.getString(PsConst.VALUE_HOLDER__WHATSAPP);
    final String? phone = shared.getString(PsConst.VALUE_HOLDER__PHONE);
    final String? appInfoVersionNo =
        shared.getString(PsConst.APPINFO_PREF_VERSION_NO);
    final bool? appInfoForceUpdate =
        shared.getBool(PsConst.APPINFO_PREF_FORCE_UPDATE);
    final String? appInfoForceUpdateTitle =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_TITLE);
    final String? appInfoForceUpdateMsg =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_MSG);
    final String? startDate =
        shared.getString(PsConst.VALUE_HOLDER__START_DATE);
    final String? endDate = shared.getString(PsConst.VALUE_HOLDER__END_DATE);
    final String? lat = shared.getString(PsConst.VALUE_HOLDER__LAT);
    final String? lng = shared.getString(PsConst.VALUE_HOLDER__LNG);
    final String? googlePlayStoreUrl =
        shared.getString(PsConst.VALUE_HOLDER__GOOGLE_PLAY_STORE_URL);
    final String? appleAppStoreUrl =
        shared.getString(PsConst.VALUE_HOLDER__APPLE_APP_STORE_URL);
    final String? defaultLanguageCode =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_CODE);
    final String? defaultLanguageCountryCode =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_COUNTRY_CODE);
    final String? defaultLanguageName =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_NAME);
    final String? priceFormat =
        shared.getString(PsConst.VALUE_HOLDER__PRICE_FORMAT);
    final String? dateFormat =
        shared.getString(PsConst.VALUE_HOLDER__DATE_FORMAT);
    final String? defaultOrderTime =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_ORDER_TIME);
    final String? iOSAppStoreId =
        shared.getString(PsConst.VALUE_HOLDER__IOS_APP_STORE_ID);
    final String? isUseThumbnailAsPlaceholder =
        shared.getString(PsConst.VALUE_HOLDER__IS_USE_THUMBNAIL_AS_PLACEHOLDER);
    final String? isShowTokenId =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_TOKEN_ID);
    final String? isShowSubCategory =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_SUB_CATEGORY);
    final String? fbKey =
        shared.getString(PsConst.VALUE_HOLDER__FB_KEY);
    final String? isShowAdmob =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_ADMOB);
    final int? defaultLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__DEFAULT_LOADING_LIMIT);
    final int? categoryLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__CATEGORY_LOADING_LIMIT);
    final int? collectionProductLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__COLLECTION_PRODUCT_LOADING_LIMIT);
    final int? discountProductLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__DISCOUNT_PRODUCT_LOADING_LIMIT);
    final int? featureProductLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__FEATURE_PRODUCT_LOADING_LIMIT);
    final int? latestProductLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__LATEST_PRODUCT_LOADING_LIMIT);
    final int? trendingProductLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__TRENDING_PRODUCT_LOADING_LIMIT);
    final int? shopLoadingLimit =
        shared.getInt(PsConst.VALUE_HOLDER__SHOP_LOADING_LIMIT);
    final String? showFacebookLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_FACEBOOK_LOGIN);
    final String? showGoogleLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_GOOGLE_LOGIN);
    final String? showPhoneLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_PHONE_LOGIN);
    final String? showMainMenu =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_MAIN_MENU);
    final String? showSpecialCollections =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_SPECIAL_COLLECTIONS);
    final String? showFeaturedItems =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_FEATURED_ITEM);
    final String? showBestChoiceSlider =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_BEST_CHOICE_SLIDER);
    final String? isRazorSupportMultiCurrency =
        shared.getString(PsConst.VALUE_HOLDER__IS_RAZOR_SUPPORT_MULTI_CURRENCY);
    final String? defaultRazorCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_RAZOR_CURRENCY);
    final String? defaultflutterWaveCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_FLUTTER_WAVE_CURRENCY);
    final String? paypalEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED);
    final String? stripeEnabled =
        shared.getString(PsConst.VALUE_HOLDER__STRIPE_ENABLED);
    final String? paystackEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYSTACK_ENABLED);
    final String? codEnabled =
        shared.getString(PsConst.VALUE_HOLDER__COD_ENABLED);
    final String? bankEnabled =
        shared.getString(PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE);
    final String? publishKey =
        shared.getString(PsConst.VALUE_HOLDER__PUBLISH_KEY);
    final String? paystackKey =
        shared.getString(PsConst.VALUE_HOLDER__PAYSTACK_KEY);

    final String? standardShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE);
    final String? zoneShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE);
    final String? noShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final String? shopName = shared.getString(PsConst.VALUE_HOLDER__SHOP_NAME);
    final String? isMulti = shared.getString(PsConst.IS_MULTI_SHOP);
    final PsValueHolder valueHolder = PsValueHolder(
        loginUserId: loginUserId,
        userIdToVerify: userIdToVerify,
        userNameToVerify: userNameToVerify,
        userEmailToVerify: userEmailToVerify,
        userPasswordToVerify: userPasswordToVerify,
        deviceToken: notiToken,
        isToShowIntroSlider: isToShowIntroSlider,
        isUserAlradyChoose: isUserAlradyChoose,
        notiSetting: notiSetting,
        overAllTaxLabel: overAllTaxLabel,
        overAllTaxValue: overAllTaxValue,
        shippingTaxLabel: shippingTaxLabel,
        shippingTaxValue: shippingTaxValue,
        minimumOrderAmount: minimumOrderAmount,
        shopId: shopId,
        shopName: shopName,
        isMulti: isMulti,
        messenger: messenger,
        whatsApp: whatsApp,
        phone: phone,
        appInfoVersionNo: appInfoVersionNo,
        appInfoForceUpdate: appInfoForceUpdate,
        appInfoForceUpdateTitle: appInfoForceUpdateTitle,
        appInfoForceUpdateMsg: appInfoForceUpdateMsg,
        startDate: startDate,
        endDate: endDate,
        lat: lat,
        lng: lng,
        googlePlayStoreUrl: googlePlayStoreUrl,
        appleAppStoreUrl: appleAppStoreUrl,
        defaultLanguageCode: defaultLanguageCode,
        defaultLanguageCountryCode: defaultLanguageCountryCode,
        defaultLanguageName: defaultLanguageName,
        priceFormat: priceFormat,
        dateFormat: dateFormat,
        defaultOrderTime: defaultOrderTime,
        iOSAppStoreId: iOSAppStoreId,
        isUseThumbnailAsPlaceholder: isUseThumbnailAsPlaceholder,
        isShowTokenId: isShowTokenId,
        isShowSubCategory: isShowSubCategory,
        fbKey: fbKey,
        isShowAdmob: isShowAdmob,
        defaultLoadingLimit: defaultLoadingLimit,
        categoryLoadingLimit: categoryLoadingLimit,
        collectionProductLoadingLimit: collectionProductLoadingLimit,
        discountProductLoadingLimit: discountProductLoadingLimit,
        featureProductLoadingLimit: featureProductLoadingLimit,
        latestProductLoadingLimit: latestProductLoadingLimit,
        trendingProductLoadingLimit: trendingProductLoadingLimit,
        shopLoadingLimit: shopLoadingLimit,
        showFacebookLogin: showFacebookLogin,
        showGoogleLogin: showGoogleLogin,
        showPhoneLogin: showPhoneLogin,
        showMainMenu: showMainMenu,
        showSpecialCollections: showSpecialCollections,
        showFeaturedItems: showFeaturedItems,
        showBestChoiceSlider: showBestChoiceSlider,
        isRazorSupportMultiCurrency: isRazorSupportMultiCurrency,
        defaultRazorCurrency: defaultRazorCurrency,
        defaultFlutterWaveCurrency: defaultflutterWaveCurrency,
        paypalEnabled: paypalEnabled,
        stripeEnabled: stripeEnabled,
        codEnabled: codEnabled,
        bankEnabled: bankEnabled,
        publishKey: publishKey,
        paystackKey: paystackKey,
        shippingId: shippingId,
        paystackEnabled: paystackEnabled,
        standardShippingEnable: standardShippingEnable,
        zoneShippingEnable: zoneShippingEnable,
        noShippingEnable: noShippingEnable);

    _valueController.add(valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_ID, loginUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  String? getNotiMessage() {
    return shared.getString(PsConst.VALUE_HOLDER__NOTI_MESSAGE);
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool showIntroSlider) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, showIntroSlider);

    loadValueHolder();
  }

  Future<dynamic> replaceIsUserAlreadyChoose(bool isUserAlreadyChoose) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE, isUserAlreadyChoose);

    loadValueHolder();
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared.setString(PsConst.VALUE_HOLDER__START_DATE, startDate);
    await shared.setString(PsConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

  Future<dynamic> replaceMobileSettingData(
    String lat,
    String lng,
    String googlePlayStoreUrl, 
    String appleAppStoreUr,
    String defaultLanguageCode,
    String defaultLanguageCountryCode,
    String defaultLanguageName,
    String priceFormat,
    String dateFormat,
    String defaultOrderTime,
    String iOSAppStoreId,
    String isUseThumbnailAsPlaceholder,
    String isShowTokenId,
    String isShowSubCategory,
    String fbKey,
    String isShowAdmob,
    String defaultLoadingLimit,
    String categoryLoadingLimit,
    String collectionProductLoadingLimit,
    String discountProductLoadingLimit,
    String featureProductLoadingLimit,
    String latestProductLoadingLimit,
    String trendingProductLoadingLimit,
    String shopLoadingLimit,
    String showFacebookLogin,
    String showGoogleLogin,
    String showPhoneLogin,
    String showMainMenu,
    String showSpecialCollections,
    String showFeaturedItems,
    String showBestChoiceSlider,
    String isRazorSupportMultiCurrency,
    String defaultRazorCurrency,
    String defaultFlutterWaveCurrency
    ) async {
    await shared.setString(PsConst.VALUE_HOLDER__LAT, lat);
    await shared.setString(PsConst.VALUE_HOLDER__LNG, lng);
    await shared.setString(
        PsConst.VALUE_HOLDER__GOOGLE_PLAY_STORE_URL, googlePlayStoreUrl);
    await shared.setString(
        PsConst.VALUE_HOLDER__APPLE_APP_STORE_URL, appleAppStoreUr);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_CODE, defaultLanguageCode);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_COUNTRY_CODE, defaultLanguageCountryCode);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_NAME, defaultLanguageName);
     await shared.setString(
        PsConst.VALUE_HOLDER__PRICE_FORMAT, priceFormat);
    await shared.setString(
        PsConst.VALUE_HOLDER__DATE_FORMAT, dateFormat);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_ORDER_TIME, defaultOrderTime);
    await shared.setString(
        PsConst.VALUE_HOLDER__IOS_APP_STORE_ID, iOSAppStoreId);
    await shared.setString(
        PsConst.VALUE_HOLDER__IS_USE_THUMBNAIL_AS_PLACEHOLDER, isUseThumbnailAsPlaceholder);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_TOKEN_ID, isShowTokenId);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_SUB_CATEGORY, isShowSubCategory);
    await shared.setString(
      PsConst.VALUE_HOLDER__FB_KEY, fbKey);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_ADMOB, isShowAdmob);
    await shared.setInt(
      PsConst.VALUE_HOLDER__DEFAULT_LOADING_LIMIT, int.parse(defaultLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__CATEGORY_LOADING_LIMIT, int.parse(categoryLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__COLLECTION_PRODUCT_LOADING_LIMIT, int.parse(collectionProductLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__DISCOUNT_PRODUCT_LOADING_LIMIT, int.parse(discountProductLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__FEATURE_PRODUCT_LOADING_LIMIT, int.parse(featureProductLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__LATEST_PRODUCT_LOADING_LIMIT, int.parse(latestProductLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__TRENDING_PRODUCT_LOADING_LIMIT, int.parse(trendingProductLoadingLimit));
    await shared.setInt(
      PsConst.VALUE_HOLDER__SHOP_LOADING_LIMIT, int.parse(shopLoadingLimit));
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_FACEBOOK_LOGIN, showFacebookLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_GOOGLE_LOGIN, showGoogleLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_PHONE_LOGIN, showPhoneLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_MAIN_MENU, showMainMenu);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_SPECIAL_COLLECTIONS, showSpecialCollections);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_FEATURED_ITEM, showFeaturedItems);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_BEST_CHOICE_SLIDER, showBestChoiceSlider);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_RAZOR_SUPPORT_MULTI_CURRENCY, isRazorSupportMultiCurrency);
    await shared.setString(
      PsConst.VALUE_HOLDER__DEFAULT_RAZOR_CURRENCY, defaultRazorCurrency);
    await shared.setString(
      PsConst.VALUE_HOLDER__DEFAULT_FLUTTER_WAVE_CURRENCY, defaultFlutterWaveCurrency);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared.setString(PsConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsapp,
    String phone,
    String minimumOrderAmount,
  ) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL, overAllTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE, overAllTaxValue);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL, shippingTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE, shippingTaxValue);
    await shared.setString(PsConst.VALUE_HOLDER__SHIPPING_ID, shippingId);
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(PsConst.VALUE_HOLDER__MESSENGER, messenger);
    await shared.setString(PsConst.VALUE_HOLDER__WHATSAPP, whatsapp);
    await shared.setString(PsConst.VALUE_HOLDER__PHONE, phone);
    await shared.setString(
        PsConst.VALUE_HOLDER__MINIMUM_ORDER_AMOUNT, minimumOrderAmount);

    loadValueHolder();
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String paystackEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED, paypalEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__STRIPE_ENABLED, stripeEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__COD_ENABLED, codEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE, bankEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE, standardShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE, zoneShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE, noShippingEnable );

    loadValueHolder();
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }

  Future<dynamic> replacePayStackKey(String pubKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYSTACK_KEY, pubKey);

    loadValueHolder();
  }

  Future<dynamic> replaceShop(String shopId, String shopName) async {
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_NAME, shopName);

    loadValueHolder();
  }

  Future<dynamic> isMultiShop(String isMulti) async {
    await shared.setString(PsConst.IS_MULTI_SHOP, isMulti);

    loadValueHolder();
  }
}
