import 'package:fluttermultigrocery/viewobject/common/language.dart';

class PsConfig {
  PsConfig._();

  ///
  /// AppVersion
  /// For your app, you need to change according based on your app version
  ///
  static const String app_version = '2.0';

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  static const String ps_api_key = 'phillipjoy';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String ps_core_url =
      'http://192.168.100.149/flutter-grocery-admin';

  static String get ps_app_url => 'http://192.168.100.149/flutter-grocery-admin/index.php/';

  static String get ps_app_image_url => 'http://192.168.100.149/flutter-grocery-admin/uploads/';

  static String get ps_app_image_thumbs_url => 'http://192.168.100.149/flutter-grocery-admin/thumbnail/';

  // Debug method to print current config values
  static void printConfig() {
    print('DEBUG: ps_core_url = $ps_core_url');
    print('DEBUG: ps_app_url = $ps_app_url');
    print('DEBUG: ps_app_image_url = $ps_app_image_url');
  }

  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 500);


  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String ps_default_font_family = 'Product Sans';

  /// Default Language
  // static const ps_default_language = 'en';

  // static const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
  static const String ps_app_db_name = 'ps_db.db';

  ///
  /// For default language change, please check
  /// LanguageFragment for language code and country code
  /// ..............................................................
  /// Language             | Language Code     | Country Code
  /// ..............................................................
  /// "English"            | "en"              | "US"
  /// "Arabic"             | "ar"              | "DZ"
  /// "India (Hindi)"      | "hi"              | "IN"
  /// "German"             | "de"              | "DE"
  /// "Spainish"           | "es"              | "ES"
  /// "French"             | "fr"              | "FR"
  /// "Indonesian"         | "id"              | "ID"
  /// "Italian"            | "it"              | "IT"
  /// "Japanese"           | "ja"              | "JP"
  /// "Korean"             | "ko"              | "KR"
  /// "Malay"              | "ms"              | "MY"
  /// "Portuguese"         | "pt"              | "PT"
  /// "Russian"            | "ru"              | "RU"
  /// "Thai"               | "th"              | "TH"
  /// "Turkish"            | "tr"              | "TR"
  /// "Chinese"            | "zh"              | "CN"
  /// ..............................................................
  ///
  ///
  static final Language defaultLanguage =
      Language(languageCode: 'en', countryCode: 'US', name: 'English');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'hi', countryCode: 'IN', name: 'Hindi'),
    Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
    Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
    Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
    Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
    Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
    Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
    Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
    Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
    Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
    Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  // static const String priceFormat = ',##0.00';

  ///
  /// Date Time Format
  ///

  // static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  ///
  /// Default Date Time For Minute
  ///
  // static const int defaultOrderTime = 20;

  ///
  /// iOS App No
  ///
  // static const String iOSAppStoreId = '000000000';
  // static const String iOSAppStoreId = '789135275';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'fluttermultigrocery';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  // static const bool USE_THUMBNAIL_AS_PLACEHOLDER = false;

  ///
  /// Token Id
  ///
  // static const bool isShowTokenId = true;

  ///
  ///ShowSubCategory
  ///
  // static const bool isShowSubCategory = true;

  ///
  /// Facebook Key
  ///
  // static const String fbKey = '1316734058679794';
  // static const String fbKey = '0000000000000000';

  ///
  ///Admob Setting
  ///
  // static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey =
      'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';
  static String androidAdMobBannerAdUnitId = 'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobBannerAdUnitId = 'ca-app-pub-0000000000000000/0000000000';

  ///
  /// Image Size
  ///
  static const int profileImageAize = 512;

  ///
  /// if demo url
  ///
  static bool isDemo = true;

  ///
  /// Default Limit
  ///
  // static const int DEFAULT_LOADING_LIMIT = 30;
  // static const int CATEGORY_LOADING_LIMIT = 12;
  // static const int COLLECTION_PRODUCT_LOADING_LIMIT = 12;
  // static const int DISCOUNT_PRODUCT_LOADING_LIMIT = 12;
  // static const int FEATURE_PRODUCT_LOADING_LIMIT = 12;
  // static const int LATEST_PRODUCT_LOADING_LIMIT = 12;
  // static const int TRENDING_PRODUCT_LOADING_LIMIT = 12;
  // static const int SHOP_LOADING_LIMIT = 10;

  ///
  /// GoogleMap, default map is Flutter Map
  ///
  static const bool isUseGoogleMap = true;

  ///
  ///Login Setting
  ///
  // static bool showFacebookLogin = true;
  // static bool showGoogleLogin = true;
  // static bool showPhoneLogin = true;

  ///
  /// Dashboard Setting
  ///
  // static bool showHome = true;
  // static bool showSpecialCollections = true;
  // static bool showFeaturedItems = true;
  // static bool showBestChoiceSlider = false;

  ///
  /// Default Location
  ///
  // static String lat = '1.331117';
  // static String lng = '103.849622';

  ///
  /// Razor Currency
  ///
  // static bool isRazorSupportMultiCurrency = false;
  // static String defaultRazorCurrency = 'INR';

  ///
  /// Flutter Wave Currency
  ///
  // static String defaultFlutterWaveCurrency = 'USD';

}
