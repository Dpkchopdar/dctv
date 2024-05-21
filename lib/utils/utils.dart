import 'dart:developer';
import 'dart:io';
import 'dart:math' as number;

import 'package:dtlive/model/qualitymodel.dart';
import 'package:dtlive/model/subtitlemodel.dart';
import 'package:dtlive/pages/loginsocial.dart';
import 'package:dtlive/pages/tvmoviedetails.dart';
import 'package:dtlive/pages/tvshowdetails.dart';
import 'package:dtlive/players/player_video.dart';
import 'package:dtlive/players/player_vimeo.dart';
import 'package:dtlive/players/player_youtube.dart';
import 'package:dtlive/provider/showdetailsprovider.dart';
import 'package:dtlive/provider/videodetailsprovider.dart';
import 'package:dtlive/subscription/allpayment.dart';
import 'package:dtlive/subscription/subscription.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:html/parser.dart' show parse;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dtlive/players/player_webview.dart';

class Utils {
  static void enableScreenCapture() async {
    // await ScreenProtector.preventScreenshotOn();
    // if (Platform.isIOS) {
    //   await ScreenProtector.protectDataLeakageWithBlur();
    // } else if (Platform.isAndroid) {
    //   await ScreenProtector.protectDataLeakageOn();
    // }
  }

  static void setDetailData({
    required int videoId,
    required int upcomingType,
    required int videoType,
    required int typeId,
  }) {
    debugPrint("setDetailData videoId ==========> $videoId");
    debugPrint("setDetailData upcomingType =====> $upcomingType");
    debugPrint("setDetailData videoType ========> $videoType");
    debugPrint("setDetailData typeId ===========> $typeId");
    Map<String, int> dataList = <String, int>{};
    dataList['videoId'] = videoId;
    dataList['upcomingType'] = upcomingType;
    dataList['videoType'] = videoType;
    dataList['typeId'] = typeId;
    debugPrint("dataList========> ${dataList.length}");
    Constant.detailIDList.clear();
    Constant.detailIDList = <String, int>{};
    Constant.detailIDList = dataList;
    debugPrint("detailIDList ==========> ${Constant.detailIDList.length}");
  }

  static setSidebarToggle(SidebarXController controller, bool isOpen) {
    debugPrint("isOpen ==========> $isOpen");
    // controller.setExtended(isOpen);
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: white,
      textColor: black,
      fontSize: 16,
    );
  }

  static Future<dynamic> openDetails({
    required BuildContext context,
    required SidebarXController controller,
    required int videoId,
    required int upcomingType,
    required int videoType,
    required int typeId,
  }) async {
    debugPrint("openDetails videoId ========> $videoId");
    debugPrint("openDetails upcomingType ===> $upcomingType");
    debugPrint("openDetails videoType ======> $videoType");
    debugPrint("openDetails typeId =========> $typeId");
    if (videoType == 5) {
      if (upcomingType == 1) {
        if (!(context.mounted)) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TVMovieDetails(
                videoId,
                upcomingType,
                videoType,
                typeId,
                controller: controller,
              );
            },
          ),
        );
      } else if (upcomingType == 2) {
        if (!(context.mounted)) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TVShowDetails(
                videoId,
                upcomingType,
                videoType,
                typeId,
                controller: controller,
              );
            },
          ),
        );
      }
    } else {
      if (videoType == 1) {
        if (!(context.mounted)) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TVMovieDetails(
                videoId,
                upcomingType,
                videoType,
                typeId,
                controller: controller,
              );
            },
          ),
        );
      } else if (videoType == 2) {
        if (!(context.mounted)) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TVShowDetails(
                videoId,
                upcomingType,
                videoType,
                typeId,
                controller: controller,
              );
            },
          ),
        );
      }
    }
  }

  static void openLogin({
    required BuildContext context,
    required SidebarXController controller,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginSocial(
            controller: controller,
          );
        },
      ),
    );
  }

  static Future<dynamic> openSubscription({
    required BuildContext context,
    required SidebarXController controller,
  }) async {
    dynamic isSubscribe = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Subscription(
            controller: controller,
          );
        },
      ),
    );
    return isSubscribe;
  }

  static Future<dynamic> paymentForRent({
    required BuildContext context,
    required String? videoId,
    required String? vTitle,
    required String? vType,
    required String? typeId,
    required String? rentPrice,
  }) async {
    dynamic isRented = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AllPayment(
            payType: 'Rent',
            itemId: videoId.toString(),
            price: rentPrice.toString(),
            itemTitle: vTitle.toString(),
            typeId: typeId.toString(),
            videoType: vType.toString(),
            productPackage: '',
            currency: '',
          );
        },
      ),
    );
    return isRented;
  }

  /* ========= Open Player ========= */
  static Future<dynamic> openPlayer({
    required BuildContext context,
    required String? playType,
    required int? videoId,
    required int? videoType,
    required int? typeId,
    required int? otherId,
    required String? videoUrl,
    required String? trailerUrl,
    required String? uploadType,
    required String? videoThumb,
    required int? vStopTime,
  }) async {
    dynamic isContinue;
    int? vID = (videoId ?? 0);
    int? vType = (videoType ?? 0);
    int? vTypeID = (typeId ?? 0);
    int? vOtherID = (otherId ?? 0);
    debugPrint("vID ========> $vID");
    debugPrint("vOtherID ===> $vOtherID");

    int? stopTime;
    if (playType == "startOver") {
      stopTime = 0;
    } else {
      stopTime = (vStopTime ?? 0);
    }

    String? vUrl, vUploadType;
    if (playType == "Trailer") {
      vUrl = (trailerUrl ?? "");
    } else {
      vUrl = (videoUrl ?? "");
    }
    vUploadType = (uploadType ?? "");
    debugPrint("stopTime ===> $stopTime");
    debugPrint("===>vUploadType $vUploadType");

    if (kIsWeb) {
      /* Pod Player & Youtube Player */
      if (!context.mounted) return;
      if (vUploadType == "youtube") {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerYoutube(
                playType == "Trailer"
                    ? "Trailer"
                    : playType == "Download"
                        ? "Download"
                        : (videoType == 2 ? "Show" : "Video"),
                vID,
                vType,
                vTypeID,
                vOtherID,
                vUrl ?? "",
                stopTime,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVideo(
                playType == "Trailer"
                    ? "Trailer"
                    : playType == "Download"
                        ? "Download"
                        : (videoType == 2 ? "Show" : "Video"),
                vID,
                vType,
                vTypeID,
                vOtherID,
                vUrl ?? "",
                stopTime,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      }
    } else {
      /* Better, Youtube & Vimeo Players */
      if (vUploadType == "youtube") {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerYoutube(
                playType == "Trailer"
                    ? "Trailer"
                    : playType == "Download"
                        ? "Download"
                        : (videoType == 2 ? "Show" : "Video"),
                vID,
                vType,
                vTypeID,
                vOtherID,
                vUrl ?? "",
                stopTime,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else if (vUploadType == "vimeo") {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVimeo(
                playType == "Trailer"
                    ? "Trailer"
                    : playType == "Download"
                        ? "Download"
                        : (videoType == 2 ? "Show" : "Video"),
                vID,
                vType,
                vTypeID,
                vOtherID,
                vUrl ?? "",
                stopTime,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else if (vUrl.contains('akamaized')) {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerWebView(
                url: vUrl,
              );
            },
          ),
        );
      } else {
        isContinue = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVideo(
                playType == "Trailer"
                    ? "Trailer"
                    : playType == "Download"
                        ? "Download"
                        : (videoType == 2 ? "Show" : "Video"),
                vID,
                vType,
                vTypeID,
                vOtherID,
                vUrl ?? "",
                stopTime,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      }
    }
    debugPrint("isContinue ===> $isContinue");
    return isContinue;
  }
  /* ========= Open Player ========= */

  /* ========= Set-up Quality URL START ========= */
  static void setQualityURLs({
    required String video320,
    required String video480,
    required String video720,
    required String video1080,
  }) {
    Map<String, String> qualityUrlList = <String, String>{};
    if (video320 != "") {
      qualityUrlList['320p'] = video320;
    }
    if (video480 != "") {
      qualityUrlList['480p'] = video480;
    }
    if (video720 != "") {
      qualityUrlList['720p'] = video720;
    }
    if (video1080 != "") {
      qualityUrlList['1080p'] = video1080;
    }
    debugPrint("qualityUrlList ==========> ${qualityUrlList.length}");
    Constant.resolutionsUrls.clear();
    Constant.resolutionsUrls = [];
    Constant.resolutionsUrls = qualityUrlList.entries
        .map((entry) => QualityModel(entry.key, entry.value))
        .toList();
    debugPrint(
        "resolutionsUrls ==========> ${Constant.resolutionsUrls.length}");
  }
  /* ========= Set-up Quality URL END =========== */

  static void clearQualitySubtitle() {
    Constant.resolutionsUrls.clear();
    Constant.resolutionsUrls = [];
    Constant.subtitleUrls.clear();
    Constant.subtitleUrls = [];
  }

  /* ========= Set-up Subtitle URL START ========= */
  static void setSubtitleURLs({
    required String subtitleUrl1,
    required String subtitleUrl2,
    required String subtitleUrl3,
    required String subtitleLang1,
    required String subtitleLang2,
    required String subtitleLang3,
  }) {
    Map<String, String> subtitleUrlList = <String, String>{};
    if (subtitleUrl1 != "") {
      subtitleUrlList[subtitleLang1] = subtitleUrl1;
    }
    if (subtitleUrl2 != "") {
      subtitleUrlList[subtitleLang2] = subtitleUrl2;
    }
    if (subtitleUrl3 != "") {
      subtitleUrlList[subtitleLang3] = subtitleUrl3;
    }
    debugPrint("subtitleUrlList========> ${subtitleUrlList.length}");
    Constant.subtitleUrls.clear();
    Constant.subtitleUrls = [];
    Constant.subtitleUrls = subtitleUrlList.entries
        .map((entry) => SubTitleModel(entry.key, entry.value))
        .toList();
    debugPrint("subtitleUrls ==========> ${Constant.subtitleUrls.length}");
  }
  /* ========= Set-up Subtitle URL END =========== */

  static void getCurrencySymbol() async {
    SharedPre sharedPref = SharedPre();
    Constant.currencySymbol = await sharedPref.read("currency_code") ?? "";
    log('Constant currencySymbol ==> ${Constant.currencySymbol}');
    Constant.currency = await sharedPref.read("currency") ?? "";
    log('Constant currency ==> ${Constant.currency}');
  }

  static setUserId(userID) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("userimage");
      await sharedPref.remove("useremail");
      await sharedPref.remove("usermobile");
      await sharedPref.remove("userpremium");
      await sharedPref.remove("usertype");
    }
    Constant.userID = await sharedPref.read("userid");
    debugPrint('setUserId userID ==> ${Constant.userID}');
  }

  static saveUserCreds({
    required userID,
    required userName,
    required userEmail,
    required userMobile,
    required userImage,
    required userPremium,
    required userType,
  }) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
      await sharedPref.save("username", userName);
      await sharedPref.save("useremail", userEmail);
      await sharedPref.save("usermobile", userMobile);
      await sharedPref.save("userimage", userImage);
      await sharedPref.save("userpremium", userPremium);
      await sharedPref.save("usertype", userType);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("userimage");
      await sharedPref.remove("useremail");
      await sharedPref.remove("usermobile");
      await sharedPref.remove("userpremium");
      await sharedPref.remove("usertype");
    }
    Constant.userID = await sharedPref.read("userid");
    debugPrint('setUserId userID ==> ${Constant.userID}');
  }

  static setFirstTime(value) async {
    SharedPre sharedPref = SharedPre();
    await sharedPref.save("seen", value);
    String seenValue = await sharedPref.read("seen");
    log('setFirstTime seen ==> $seenValue');
  }

  static Future<String> getPrivacyTandCText(
      String privacyUrl, String termsConditionUrl) async {
    debugPrint('privacyUrl ==> $privacyUrl');
    debugPrint('T&C Url =====> $termsConditionUrl');

    String strPrivacyAndTNC =
        "<p style=color:white; > By continuing , I understand and agree with <a href=$privacyUrl>Privacy Policy</a> and <a href=$termsConditionUrl>Terms and Conditions</a> of ${Constant.appName}. </p>";

    debugPrint('strPrivacyAndTNC =====> $strPrivacyAndTNC');
    return strPrivacyAndTNC;
  }

  static Future<void> deleteCacheDir() async {
    if (Platform.isAndroid) {
      var tempDir = await getTemporaryDirectory();

      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    }
  }

  static BoxDecoration textFieldBGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: otherColor,
        width: .2,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r4BGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: otherColor,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradientBGWithCenter(
      Color colorStart, Color colorCenter, Color colorEnd, double radius) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorStart, colorCenter, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r4DarkBGWithBorder() {
    return BoxDecoration(
      color: colorPrimaryDark,
      border: Border.all(
        color: colorPrimaryDark,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration r10BGWithBorder() {
    return BoxDecoration(
      color: white,
      border: Border.all(
        color: otherColor,
        width: .5,
      ),
      borderRadius: BorderRadius.circular(10),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBackground(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBGWithBorder(
      Color color, Color borderColor, double radius, double border) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration primaryDarkButton() {
    return BoxDecoration(
      color: colorPrimaryDark,
      borderRadius: BorderRadius.circular(4),
      shape: BoxShape.rectangle,
    );
  }

  static Widget buildBackBtn(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      focusColor: gray.withOpacity(0.5),
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: MyImage(
          height: 17,
          width: 17,
          imagePath: "back.png",
          fit: BoxFit.contain,
          color: white,
        ),
      ),
    );
  }

  static Widget buildBackBtnDesign(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MyImage(
        height: 17,
        width: 17,
        imagePath: "back.png",
        fit: BoxFit.contain,
        color: white,
      ),
    );
  }

  static AppBar myAppBar(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBgColor,
      centerTitle: true,
      title: MyText(
        color: colorPrimary,
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsizeNormal: 16,
        fontsizeWeb: 18,
        maxline: 1,
        overflow: TextOverflow.ellipsis,
        fontweight: FontWeight.bold,
        textalign: TextAlign.center,
        fontstyle: FontStyle.normal,
      ),
    );
  }

  static AppBar myAppBarWithBack(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      elevation: 5,
      backgroundColor: appBgColor,
      centerTitle: true,
      leading: IconButton(
        autofocus: true,
        focusColor: white.withOpacity(0.5),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: MyImage(
          imagePath: "back.png",
          fit: BoxFit.contain,
          height: 17,
          width: 17,
          color: white,
        ),
      ),
      title: MyText(
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsizeNormal: 16,
        fontsizeWeb: 18,
        fontstyle: FontStyle.normal,
        fontweight: FontWeight.bold,
        textalign: TextAlign.center,
        color: colorPrimary,
      ),
    );
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorPrimary,
      ),
    );
  }

  static void showSnackbar(BuildContext context, String showFor, String message,
      bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? failureBG
            : showFor == "info"
                ? infoBG
                : showFor == "success"
                    ? successBG
                    : complimentryColor,
        content: MyText(
          text: message,
          fontsizeNormal: 14,
          fontsizeWeb: 14,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontweight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static void showProgress(
      BuildContext context, ProgressDialog prDialog) async {
    debugPrint("width =======> ${MediaQuery.of(context).size.width}");
    prDialog = ProgressDialog(context);

    //For normal dialog
    prDialog = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: false,
      showLogs: false,
      customBody: Container(
        height: 80,
        width: MediaQuery.of(context).size.width > 400
            ? 300
            : MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: pageLoader(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyText(
                color: black,
                multilanguage: false,
                text: pleaseWait,
                fontsizeNormal: 12,
                fontweight: FontWeight.w700,
                fontsizeWeb: 18,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );

    prDialog.style(
      borderRadius: 8,
      maxProgress: 100,
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
    );

    await prDialog.show();
  }

  static String convertToColonText(int timeInMilli) {
    String convTime = "";

    try {
      log("timeInMilli ==> ${(timeInMilli / 1000)}");
      if (timeInMilli > 0) {
        int seconds = ((timeInMilli / 1000) % 60).toInt();
        int minutes = ((timeInMilli / (1000 * 60)) % 60).toInt();
        int hours = ((timeInMilli / (1000 * 60 * 60)) % 24).toInt();

        if (hours >= 1) {
          if (minutes > 0 && seconds > 0) {
            convTime = "$hours : $minutes : $seconds hr";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "$hours : $minutes : 00 hr";
          } else if (minutes == 0 && seconds > 0) {
            convTime = "$hours : 00 : $seconds hr";
          } else if (minutes == 0 && seconds == 0) {
            convTime = "$hours : 00 hr";
          }
        } else if (minutes > 0) {
          if (seconds > 0) {
            convTime = "$minutes : $seconds min";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "$minutes : 00 min";
          }
        } else if (seconds > 0) {
          convTime = "00 : $seconds sec";
        }
      } else {
        convTime = "0";
      }
    } catch (e) {
      log("ConvTimeE Exception ==> $e");
    }
    return convTime;
  }

  static String convertTimeToText(int timeInMilli) {
    String convTime = "";

    try {
      log("timeInMilli ==> $timeInMilli");
      if (timeInMilli > 0) {
        double seconds = ((timeInMilli / 1000) % 60);
        double minutes = ((timeInMilli / (1000 * 60)) % 60);
        double hours = ((timeInMilli / (1000 * 60 * 60)) % 24);

        if (hours >= 1) {
          if (minutes > 0 && seconds > 0) {
            convTime =
                "${hours.toInt()} hr ${minutes.toInt()} min ${seconds.toInt()} sec";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "${hours.toInt()} hr ${minutes.toInt()} min";
          } else if (minutes == 0 && seconds > 0) {
            convTime = "${hours.toInt()} hr ${seconds.toInt()} sec";
          } else if (minutes == 0 && seconds == 0) {
            convTime = "${hours.toInt()} hr";
          }
        } else if (minutes > 0) {
          if (seconds > 0) {
            convTime = "${minutes.toInt()} min ${seconds.toInt()} sec";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "${minutes.toInt()} min";
          }
        } else if (seconds > 0) {
          convTime = "${seconds.toInt()} sec";
        }
      } else {
        convTime = "0";
      }
    } catch (e) {
      log("ConvTimeE Exception ==> $e");
    }
    return convTime;
  }

  static String remainTimeInMin(int remainWatch) {
    String convTime = "";

    try {
      log("remainWatch ==> ${(remainWatch / 1000)}");
      if (remainWatch > 0) {
        double seconds = ((remainWatch / 1000) % 60);
        double minutes = ((remainWatch / (1000 * 60)) % 60);
        double hours = ((remainWatch / (1000 * 60 * 60)) % 24);

        if (hours >= 1) {
          if (minutes > 0 && seconds > 0) {
            convTime =
                "${hours.toInt()} hr ${minutes.toInt()} min ${seconds.toInt()} sec";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "${hours.toInt()} hr ${minutes.toInt()} min";
          } else if (minutes == 0 && seconds > 0) {
            convTime = "${hours.toInt()} hr ${seconds.toInt()} sec";
          } else if (minutes == 0 && seconds == 0) {
            convTime = "${hours.toInt()} hr";
          }
        } else if (minutes > 0) {
          if (seconds > 0) {
            convTime = "${minutes.toInt()} min ${seconds.toInt()} sec";
          } else if (minutes > 0 && seconds == 0) {
            convTime = "${minutes.toInt()} min";
          }
        } else if (seconds > 0) {
          convTime = "${seconds.toInt()} sec";
        }
      } else {
        convTime = "0";
      }
    } catch (e) {
      log("ConvTimeE Exception ==> $e");
    }
    return convTime;
  }

  static String convertInMin(int remainWatch) {
    String convTime = "";

    try {
      if (remainWatch > 0) {
        double minutes = ((remainWatch / (1000 * 60)) % 60);
        double seconds = ((remainWatch / 1000) % 60);
        if (minutes >= 0 && minutes < 1) {
          convTime = "${seconds.toInt()} sec";
        } else if (minutes >= 1 && minutes < 10) {
          convTime = "0${minutes.toInt()} min";
        } else {
          convTime = "${minutes.toInt()} min";
        }
      } else {
        convTime = "00 min";
      }
    } catch (e) {
      log("convertInMin Exception ==> $e");
    }
    return convTime;
  }

  static double getPercentage(int totalValue, int usedValue) {
    double percentage = 0.0;
    try {
      if (totalValue != 0) {
        percentage = ((usedValue / totalValue).clamp(0.0, 1.0) * 100);
      } else {
        percentage = 0.0;
      }
    } catch (e) {
      log("getPercentage Exception ==> $e");
      percentage = 0.0;
    }
    percentage = (percentage.round() / 100);
    return percentage;
  }

  //Convert Html to simple String
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  static Future<String> getFileUrl(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName";
  }

  static Future<File?> saveImageInStorage(imgUrl) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${DateTime.now().millisecondsSinceEpoch.toString()}.png'));
      file.writeAsBytesSync(response.bodyBytes);
      // This is a sync operation on a real
      // app you'd probably prefer to use writeAsByte and handle its Future
      return file;
    } catch (e) {
      debugPrint("saveImageInStorage Exception ===> $e");
      return null;
    }
  }

  static Html htmlTexts(var strText) {
    return Html(
      data: strText,
      style: {
        "body": Style(
          color: otherColor,
          fontSize: FontSize((kIsWeb || Constant.isTV) ? 12 : 15),
          fontWeight: FontWeight.w500,
        ),
        "link": Style(
          color: colorPrimaryDark,
          fontSize: FontSize((kIsWeb || Constant.isTV) ? 12 : 15),
          fontWeight: FontWeight.w500,
        ),
      },
      onLinkTap: (url, _, ___) async {
        if (await canLaunchUrl(Uri.parse(url!))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.platformDefault,
          );
        } else {
          throw 'Could not launch $url';
        }
      },
      shrinkWrap: false,
    );
  }

  static Future<void> redirectToUrl(String url) async {
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> redirectToStore() async {
    final appId =
        Platform.isAndroid ? Constant.appPackageName : Constant.appleAppId;
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    debugPrint("fixFourDigit =>>> ${Constant.fixFourDigit}");
    debugPrint("fixSixDigit =>>> ${Constant.fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    debugPrint("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    debugPrint("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    debugPrint("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant.fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant.fixSixDigit.toInt()}"
        "$getRandomNumber";
    debugPrint("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */

  /* ***************** Download ***************** */
  static Future<String> prepareSaveDir() async {
    String localPath = (await _getSavedDir())!;
    log("localPath ------------> $localPath");
    final savedDir = Directory(localPath);
    log("savedDir -------------> $savedDir");
    log("is exists ? ----------> ${savedDir.existsSync()}");
    if (!(await savedDir.exists())) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      try {
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      } catch (err, st) {
        log('failed to get downloads path: $err, $st');
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    log("externalStorageDirPath ------------> $externalStorageDirPath");
    return externalStorageDirPath;
  }

  static Future<String> prepareShowSaveDir(
      String showName, String seasonName) async {
    log("showName -------------> $showName");
    log("seasonName -------------> $seasonName");
    String localPath = (await _getShowSavedDir(showName, seasonName))!;
    final savedDir = Directory(localPath);
    log("savedDir -------------> $savedDir");
    log("savedDir path --------> ${savedDir.path}");
    if (!savedDir.existsSync()) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getShowSavedDir(
      String showName, String seasonName) async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      } catch (err, st) {
        log('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          "${(await getApplicationDocumentsDirectory()).absolute.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
    }
    return externalStorageDirPath;
  }

  static Future<void> setDownloadComplete(
      BuildContext context,
      String downloadType,
      int? itemId,
      int? videoType,
      int? typeId,
      int? otherId) async {
    if (downloadType == "Show") {
      final showDetailsProvider =
          Provider.of<ShowDetailsProvider>(context, listen: false);
      showDetailsProvider.setDownloadComplete(
        context,
        itemId,
        videoType,
        typeId,
        otherId,
      );
    } else if (downloadType == "Video") {
      final videoDetailsProvider =
          Provider.of<VideoDetailsProvider>(context, listen: false);
      videoDetailsProvider.setDownloadComplete(
        context,
        itemId,
        videoType,
        typeId,
      );
    }
  }
  /* ***************** Download ***************** */
}
