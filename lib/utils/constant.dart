import 'package:dtlive/model/qualitymodel.dart';
import 'package:dtlive/model/subtitlemodel.dart';

class Constant {
  static const String baseurl = 'https://dcplay.in/admin_panel/public/api/';

  static String? appName = "DTLive";
  static String? appPackageName = "com.dclive.dcplaytv";
  static String? appleAppId = "6449380090";

  /* OneSignal App ID */
  static const String oneSignalAppId = "";

  /* Constant for TV check */
  static bool isTV = false;

  static String? userID;
  static String currencySymbol = "";
  static String currency = "";

  static String androidAppShareUrlDesc =
      "Let me recommend you this application\n\n$androidAppUrl";
  static String iosAppShareUrlDesc =
      "Let me recommend you this application\n\n$iosAppUrl";

  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://apps.apple.com/us/app/id${Constant.appleAppId}";
  static String facebookUrl = "https://www.facebook.com/divinetechs";
  static String instagramUrl = "https://www.instagram.com/divinetechs/";

  static List<QualityModel> resolutionsUrls = [];
  static List<SubTitleModel> subtitleUrls = [];
  static Map<String, int> detailIDList = <String, int>{};

  /* Download config */
  static String videoDownloadPort = 'video_downloader_send_port';
  static String showDownloadPort = 'show_downloader_send_port';
  static String hawkVIDEOList = "myVideoList_";
  static String hawkKIDSVIDEOList = "myKidsVideoList_";
  static String hawkSHOWList = "myShowList_";
  static String hawkSEASONList = "mySeasonList_";
  static String hawkEPISODEList = "myEpisodeList_";
  /* Download config */

  static int fixFourDigit = 1317;
  static int fixSixDigit = 161613;
  static int bannerDuration = 10000; // in milliseconds
  static int animationDuration = 800; // in milliseconds

  static String otpMobileNumber = "";
}
