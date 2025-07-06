import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttermultigrocery/api/common/ps_resource.dart';
import 'package:fluttermultigrocery/api/common/ps_status.dart';
import 'package:fluttermultigrocery/config/ps_colors.dart';
import 'package:fluttermultigrocery/config/ps_config.dart';
import 'package:fluttermultigrocery/constant/ps_constants.dart';
import 'package:fluttermultigrocery/constant/ps_dimens.dart';
import 'package:fluttermultigrocery/constant/route_paths.dart';
import 'package:fluttermultigrocery/provider/app_info/app_info_provider.dart';
import 'package:fluttermultigrocery/provider/clear_all/clear_all_data_provider.dart';
import 'package:fluttermultigrocery/provider/language/language_provider.dart';
import 'package:fluttermultigrocery/repository/app_info_repository.dart';
import 'package:fluttermultigrocery/repository/clear_all_data_repository.dart';
import 'package:fluttermultigrocery/repository/language_repository.dart';
import 'package:fluttermultigrocery/ui/common/dialog/version_update_dialog.dart';
import 'package:fluttermultigrocery/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultigrocery/utils/utils.dart';
import 'package:fluttermultigrocery/viewobject/common/language.dart';
import 'package:fluttermultigrocery/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/app_info_parameter_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intent_holder/shop_data_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/holder/intro_slider_intent_holder.dart';
import 'package:fluttermultigrocery/viewobject/ps_app_info.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppLoadingView extends StatelessWidget {
  Future<dynamic> callDateFunction(AppInfoProvider provider, LanguageProvider languageProvider,
      ClearAllDataProvider clearAllDataProvider, BuildContext context) async {
    String realStartDate = '0';
    String realEndDate = '0';
    PSAppInfo? psAppInfo;
    AppInfoParameterHolder appInfoParameterHolder;
    if (await Utils.checkInternetConnectivity()) {
      if (provider.psValueHolder == null ||
          provider.psValueHolder!.startDate == null) {
        realStartDate =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      } else {
        realStartDate = provider.psValueHolder!.endDate!;
      }
      appInfoParameterHolder = AppInfoParameterHolder(
          startDate: realStartDate,
          endDate: realEndDate,
          userId: Utils.checkUserLoginId(provider.psValueHolder!));

      realEndDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      final PsResource<PSAppInfo> psAppInfo0 =
          await provider.loadDeleteHistory(appInfoParameterHolder.toMap());

      if (psAppInfo0.status == PsStatus.SUCCESS) {
        await provider.replaceDate(realStartDate, realEndDate);

        if (psAppInfo0.data!.mobileSetting != null) {
          await provider.replaceMobileSettingData(
              psAppInfo0.data!.mobileSetting!.lat ?? '',
              psAppInfo0.data!.mobileSetting!.lng ?? '',
              psAppInfo0.data!.mobileSetting!.googlePlayStoreUrl ?? '', 
              psAppInfo0.data!.mobileSetting!.appleAppStoreUrl ?? '',
              psAppInfo0.data!.mobileSetting!.defaultLanguage?.languageCode ?? '',
              psAppInfo0.data!.mobileSetting!.defaultLanguage?.countryCode ?? '', 
              psAppInfo0.data!.mobileSetting!.defaultLanguage?.name ?? '',
              psAppInfo0.data!.mobileSetting!.priceFormat ?? '',
              psAppInfo0.data!.mobileSetting!.dateFormat ?? '',
              psAppInfo0.data!.mobileSetting!.defaultOrderTime ?? '',
              psAppInfo0.data!.mobileSetting!.iosAppStoreId ?? '',
              psAppInfo0.data!.mobileSetting!.isUseThumbnailAsPlaceholder ?? '',
              psAppInfo0.data!.mobileSetting!.isShowTokenId ?? '',
              psAppInfo0.data!.mobileSetting!.isShowSubCategory ?? '',
              psAppInfo0.data!.mobileSetting!.fbKey ?? '',
              psAppInfo0.data!.mobileSetting!.isShowAdmob ?? '',
              psAppInfo0.data!.mobileSetting!.defaultLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.categoryLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.collectionProductLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.discountProductLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.featureProductLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.latestProductLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.trendingProductLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.shopLoadingLimit ?? '',
              psAppInfo0.data!.mobileSetting!.showFacebookLogin ?? '',
              psAppInfo0.data!.mobileSetting!.showGoogleLogin ?? '',
              psAppInfo0.data!.mobileSetting!.showPhoneLogin ?? '',
              psAppInfo0.data!.mobileSetting!.showMainMenu ?? '',
              psAppInfo0.data!.mobileSetting!.showSpecialCollections ?? '',
              psAppInfo0.data!.mobileSetting!.showFeaturedItems ?? '',
              psAppInfo0.data!.mobileSetting!.showBestChoiceSlider ?? '',
              psAppInfo0.data!.mobileSetting!.isRazorSupportMultiCurrency ?? '',
              psAppInfo0.data!.mobileSetting!.defaultRazorCurrency ?? '',
              psAppInfo0.data!.mobileSetting!.defaultFlutterWaveCurrency ?? '',
              );
          
          await provider.isMultiShop(psAppInfo0.data!.shopObject!.ismulti!);

          final Language languageFromApi = psAppInfo0.data!.mobileSetting!.defaultLanguage!;
          languageProvider.saveApiDefaultLanguage(languageFromApi);

          if(provider.psValueHolder!.isUserAlradyChoose != true) { 
          if (!languageProvider.isUserChangesLocalLanguage() && 
                psAppInfo0.data!.mobileSetting!.defaultLanguage != null) {
            await languageProvider.addLanguage(languageFromApi);
            EasyLocalization.of(context)?.setLocale(Locale(languageFromApi.languageCode!, languageFromApi.countryCode));
          }
         } 
         if (psAppInfo0.data!.mobileSetting!.excludedLanguages != null) {
            await languageProvider.replaceExcludedLanguages(
              psAppInfo0.data!.mobileSetting!.excludedLanguages!
            );
          }
        }
       
        print(Utils.getString(context, 'app_info__cancel_button_name'));
        print(Utils.getString(context, 'app_info__update_button_name'));

        if (psAppInfo0.data!.userInfo!.userStatus == PsConst.USER_BANNED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__banned'),
                  onPressed: () {
                    checkVersionNumber(context, psAppInfo0.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (psAppInfo0.data!.userInfo!.userStatus ==
            PsConst.USER_DELECTED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__deleted'),
                  onPressed: () {
                    checkVersionNumber(context, psAppInfo0.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (psAppInfo0.data!.userInfo!.userStatus ==
            PsConst.USER_UN_PUBLISHED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__unpublished'),
                  onPressed: () {
                    checkVersionNumber(context, psAppInfo0.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else {
          checkVersionNumber(
              context, psAppInfo0.data!, provider, clearAllDataProvider);
          realStartDate = realEndDate;
        }
      } else if (psAppInfo0.status == PsStatus.ERROR) {
        final PsValueHolder valueHolder =
            Provider.of<PsValueHolder>(context, listen: false);
        if (valueHolder.isToShowIntroSlider == true) {
             Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
                arguments: IntroSliderIntentHolder(
                    settingSlider: 0,
                    psAppInfo: psAppInfo0.data)
              );
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.home,
          );
        }
      }
    } else {
      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);
      if (valueHolder.isToShowIntroSlider == true) {
          Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: IntroSliderIntentHolder(
                settingSlider: 0,
                psAppInfo: psAppInfo!)
          );
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    }
  }

  Future<void> callLogout(
      AppInfoProvider appInfoProvider,
      int index,
      BuildContext context,
  ) async {
    await appInfoProvider.replaceLoginUserId('');
    await appInfoProvider.replaceLoginUserName('');
    await FacebookAuth.instance.logOut();
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }


  final Widget _imageWidget = SizedBox(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/flutter_grocery_logo.png',
    ),
  );

  AppLoadingView({super.key});

  dynamic checkVersionNumber(
      BuildContext context,
      PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider,
      ClearAllDataProvider clearAllDataProvider) async {
    if (PsConfig.app_version != psAppInfo.psAppVersion!.versionNo) {
      if (psAppInfo.psAppVersion!.versionNeedClearData == PsConst.ONE) {
        await clearAllDataProvider.clearAllData();
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      } else {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      }
    } else {
      await appInfoProvider.replaceVersionForceUpdateData(false);
      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);
      if (valueHolder.isToShowIntroSlider == true) {
        Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: IntroSliderIntentHolder(
                settingSlider: 0,
                psAppInfo: psAppInfo)
          );
      } else {
        final PsValueHolder valueHolder =
            Provider.of<PsValueHolder>(context, listen: false);
        if (valueHolder.isToShowIntroSlider == true) {
          Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
              arguments: IntroSliderIntentHolder(
                  settingSlider: 0,
                  psAppInfo: psAppInfo)
          );
        } else {
          if (psAppInfo.shopObject!.ismulti == '1') {
            Navigator.pushReplacementNamed(
              context,
              RoutePaths.home,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              RoutePaths.home,
            );
          }
        }
      }
    }
  }

  dynamic checkForceUpdate(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) async {
    if (psAppInfo.psAppVersion!.versionForceUpdate == PsConst.ONE) {
      await appInfoProvider.replaceAppInfoData(
          psAppInfo.psAppVersion!.versionNo!,
          true,
          psAppInfo.psAppVersion!.versionTitle!,
          psAppInfo.psAppVersion!.versionMessage!);

      Navigator.pushReplacementNamed(
        context,
        RoutePaths.force_update,
        arguments: psAppInfo.psAppVersion,
      );
    } else if (psAppInfo.psAppVersion!.versionForceUpdate == PsConst.ZERO) {
      await appInfoProvider.replaceVersionForceUpdateData(false);
      callVersionUpdateDialog(context, psAppInfo);
    } else {
      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);
      if (valueHolder.isToShowIntroSlider == true) {
        Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: IntroSliderIntentHolder(
                settingSlider: 0,
                psAppInfo: psAppInfo)
          );
      } else {
        final PsValueHolder valueHolder =
            Provider.of<PsValueHolder>(context, listen: false);
        if (valueHolder.isToShowIntroSlider == true) {
          Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
              arguments: IntroSliderIntentHolder(
                  settingSlider: 0,
                  psAppInfo: psAppInfo)
          );
        } else {
          if (psAppInfo.shopObject!.ismulti == '1') {
            Navigator.pushReplacementNamed(
              context,
              RoutePaths.home,
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              RoutePaths.home,
            );
          }
        }
      }
    }
  }

  dynamic callVersionUpdateDialog(BuildContext context, PSAppInfo psAppInfo) {
    showDialog<dynamic>(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return VersionUpdateDialog(
                title: psAppInfo.psAppVersion!.versionTitle!,
                description: psAppInfo.psAppVersion!.versionMessage!,
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText:
                    Utils.getString(context, 'app_info__update_button_name'),
                onCancelTap: () {
                  final PsValueHolder valueHolder =
                      Provider.of<PsValueHolder>(context, listen: false);
                  if (valueHolder.isToShowIntroSlider == true) {
                    Navigator.pushReplacementNamed(
                        context, RoutePaths.introSlider,
                        arguments: IntroSliderIntentHolder(
                            settingSlider: 0,
                            psAppInfo: psAppInfo));
                  } else {
                    if (psAppInfo.shopObject!.ismulti == '1') {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    }
                  }
                },
                onUpdateTap: () async {
                  final PsValueHolder valueHolder =
                      Provider.of<PsValueHolder>(context, listen: false);
                  if (valueHolder.isToShowIntroSlider == true) {
                    Navigator.pushReplacementNamed(
                        context, RoutePaths.introSlider,
                        arguments: IntroSliderIntentHolder(
                            settingSlider: 0,
                            psAppInfo: psAppInfo));
                  } else {
                    if (psAppInfo.shopObject!.ismulti == '1') {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    }
                  }
                },
              );
        });
  }

  void someNavigationFunction(BuildContext context) {
    print('DEBUG: Forcing navigation to /home (multi-shop dashboard)');
    Navigator.pushReplacementNamed(context, RoutePaths.home);
    return;
    // ... rest of the navigation logic (now unreachable) ...
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      print('DEBUG: Forcing navigation to /home (multi-shop dashboard)');
      Navigator.pushReplacementNamed(context, RoutePaths.home);
    });
    return const SizedBox.shrink(); // Optionally show a loading spinner
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({super.key, 
    required this.provider,
    required this.text,
  });
  final AppInfoProvider? provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(PsColors.loadingCircleColor),
        strokeWidth: 5.0);
  }
}
