import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dtlive/pages/activetv.dart';
import 'package:dtlive/pages/home.dart';
import 'package:dtlive/pages/otpverify.dart';
import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class LoginSocial extends StatefulWidget {
  const LoginSocial({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<LoginSocial> createState() => LoginSocialState();
}

class LoginSocialState extends State<LoginSocial> {
  late GeneralProvider generalProvider;
  late ProgressDialog prDialog;
  SharedPre sharePref = SharedPre();
  final numberController = TextEditingController();
  String strCountryCode = "+91";
  String? mobileNumber,
      email,
      userName,
      strType,
      strPrivacyAndTNC,
      privacyUrl,
      termsConditionUrl,
      strDeviceToken = "",
      strDeviceType = "1";
  File? mProfileImg;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    super.initState();
    prDialog = ProgressDialog(context);
    _getData();
  }

  _getData() async {
    String? privacyUrl, termsConditionUrl;
    await generalProvider.getPages();
    if (!generalProvider.loading) {
      if (generalProvider.pagesModel.status == 200 &&
          generalProvider.pagesModel.result != null) {
        if ((generalProvider.pagesModel.result?.length ?? 0) > 0) {
          for (var i = 0;
              i < (generalProvider.pagesModel.result?.length ?? 0);
              i++) {
            if ((generalProvider.pagesModel.result?[i].pageName ?? "")
                .toLowerCase()
                .contains("privacy")) {
              privacyUrl = generalProvider.pagesModel.result?[i].url;
            }
            if ((generalProvider.pagesModel.result?[i].pageName ?? "")
                .toLowerCase()
                .contains("terms")) {
              termsConditionUrl = generalProvider.pagesModel.result?[i].url;
            }
          }
        }
      }
    }
    debugPrint('privacyUrl ==> $privacyUrl');
    debugPrint('termsConditionUrl ==> $termsConditionUrl');

    strPrivacyAndTNC = await Utils.getPrivacyTandCText(
        privacyUrl ?? "", termsConditionUrl ?? "");
    try {
      strDeviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("FirebaseMessaging Exception ===> $e");
    }
    debugPrint("strDeviceToken ===> $strDeviceToken");

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width > 400
                ? 400
                : MediaQuery.of(context).size.width,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!kIsWeb)
                  Align(
                    alignment: Alignment.topLeft,
                    child: FocusBase(
                      focusColor: white.withOpacity(0.5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      onFocus: (isFocused) {},
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: MyImage(
                          fit: BoxFit.contain,
                          imagePath: "back.png",
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                Container(
                  width: 170,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: MyImage(
                    fit: BoxFit.fill,
                    imagePath: "appicon.png",
                  ),
                ),
                const SizedBox(height: 10),
                MyText(
                  color: white,
                  text: "welcomeback",
                  fontsizeNormal: 18,
                  fontsizeWeb: 18,
                  multilanguage: true,
                  fontweight: FontWeight.bold,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.start,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 7),
                MyText(
                  color: otherColor,
                  text: "login_with_mobile_note",
                  fontsizeNormal: 14,
                  fontsizeWeb: 14,
                  multilanguage: true,
                  fontweight: FontWeight.w500,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.start,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 20),

                /* Enter Mobile Number */
                _buildCountryMobile(),
                const SizedBox(height: 20),

                /* Login Button */
                FocusBase(
                  focusColor: white,
                  onFocus: (isFocused) {},
                  onPressed: () {
                    mobileNumber = numberController.text.toString();
                    debugPrint("Click mobileNumber ====> $mobileNumber");
                    debugPrint("Click strCountryCode ==> $strCountryCode");
                    if (strCountryCode.isEmpty) {
                      Utils.showSnackbar(
                          context, "info", "select_country", true);
                    } else if (numberController.text.toString().isEmpty) {
                      Utils.showSnackbar(
                          context, "info", "login_with_mobile_note", true);
                    } else {
                      debugPrint("strCountryCode ==> $strCountryCode");
                      debugPrint("mobileNumber ====> $mobileNumber");
                      if (strCountryCode.contains("+")) {
                        Constant.otpMobileNumber =
                            "$strCountryCode${(mobileNumber ?? "")}";
                      } else {
                        Constant.otpMobileNumber =
                            "+$strCountryCode${(mobileNumber ?? "")}";
                      }
                      debugPrint(
                          "otpMobileNumber ====> ${Constant.otpMobileNumber}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OTPVerify(
                              controller: widget._controller,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width > 720
                        ? (MediaQuery.of(context).size.width * 0.4)
                        : 200,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          primaryLight,
                          primaryDark,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: MyText(
                      color: white,
                      text: "login",
                      multilanguage: true,
                      fontsizeNormal: 17,
                      fontsizeWeb: 19,
                      fontweight: FontWeight.w700,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /* Privacy & TermsCondition link */
                if (strPrivacyAndTNC != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    width: (MediaQuery.of(context).size.width * 0.5),
                    child: Utils.htmlTexts(strPrivacyAndTNC),
                  ),
                const SizedBox(height: 10),

                /* Or */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 1,
                      color: colorAccent,
                    ),
                    const SizedBox(width: 15),
                    MyText(
                      color: otherColor,
                      text: "or",
                      multilanguage: true,
                      fontsizeNormal: 14,
                      fontsizeWeb: 16,
                      fontweight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 80,
                      height: 1,
                      color: colorAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /* Google Login Button */
                FocusBase(
                  focusColor: gray.withOpacity(0.5),
                  onFocus: (isFocused) {},
                  onPressed: () {
                    debugPrint("Clicked on : ====> loginWith Google");
                    _gmailLogin();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width > 720
                        ? (MediaQuery.of(context).size.width * 0.4)
                        : 200,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: Utils.setBackground(white, 4),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage(
                          width: 30,
                          height: 30,
                          imagePath: "ic_google.png",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 30),
                        MyText(
                          color: black,
                          text: "loginwithgoogle",
                          fontsizeNormal: 14,
                          fontsizeWeb: 16,
                          multilanguage: true,
                          fontweight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /* Tv Code Button */
                FocusBase(
                  focusColor: gray.withOpacity(0.5),
                  onFocus: (isFocused) {},
                  onPressed: () {
                    debugPrint("Clicked on : ====> loginWith TV Code");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ActiveTV(
                            controller: widget._controller,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width > 720
                        ? (MediaQuery.of(context).size.width * 0.4)
                        : 200,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: Utils.setBackground(white, 4),
                    alignment: Alignment.center,
                    child: MyText(
                      color: black,
                      text: "active_tv",
                      fontsizeNormal: 14,
                      fontsizeWeb: 16,
                      multilanguage: true,
                      fontweight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryMobile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 720
          ? (MediaQuery.of(context).size.width * 0.5)
          : 200,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration:
                Utils.setBGWithBorder(transparentColor, colorPrimary, 5, 0.7),
            child: FocusBase(
              focusColor: gray.withOpacity(0.4),
              onFocus: (isFocused) {},
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: CountryPickerDropdown(
                itemHeight: 50,
                isDense: false,
                iconSize: 20,
                selectedItemBuilder: (Country country) =>
                    _buildDropdownSelectedItemBuilder(country),
                itemBuilder: (Country country) =>
                    _buildDropdownItem(country, 100),
                initialValue: 'IN',
                sortComparator: (Country a, Country b) =>
                    a.isoCode.compareTo(b.isoCode),
                onValuePicked: (Country country) {
                  debugPrint("country name ======> ${country.name}");
                  strCountryCode = country.phoneCode;
                  debugPrint(
                      "onChanged strCountryCode ========> $strCountryCode");
                },
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildTextFormField(
              controller: numberController,
              hintText: enterYourMobileNumber,
              inputType: TextInputType.phone,
              readOnly: false,
              isEnable: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(width: 8),
            Expanded(
              child: MyText(
                multilanguage: false,
                color: black,
                text: "+${country.phoneCode}(${country.isoCode})",
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                fontsizeNormal: 14,
                maxline: 1,
                fontsizeWeb: 14,
                fontweight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(Country country) => SizedBox(
        width: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(width: 8),
            Expanded(
              child: MyText(
                multilanguage: false,
                color: white,
                text: "+${country.phoneCode}",
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                fontsizeNormal: 14,
                maxline: 1,
                fontsizeWeb: 14,
                fontweight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType inputType,
    required bool readOnly,
    required bool isEnable,
  }) {
    return TextFormField(
      enabled: isEnable,
      controller: controller,
      keyboardType: inputType,
      textInputAction: TextInputAction.next,
      obscureText: false,
      maxLines: 1,
      readOnly: readOnly,
      cursorColor: colorPrimary,
      cursorRadius: const Radius.circular(2),
      decoration: InputDecoration(
        filled: true,
        isDense: false,
        fillColor: transparentColor,
        focusedBorder: const GradientOutlineInputBorder(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorPrimary, colorPrimary],
          ),
          width: 1,
        ),
        border: GradientOutlineInputBorder(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryDark.withOpacity(0.5),
              primaryDark.withOpacity(0.5)
            ],
          ),
          width: 1,
        ),
        label: MyText(
          multilanguage: false,
          color: white,
          text: hintText,
          textalign: TextAlign.start,
          fontstyle: FontStyle.normal,
          fontsizeNormal: 14,
          fontsizeWeb: 14,
          fontweight: FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: GoogleFonts.inter(
        textStyle: const TextStyle(
          fontSize: 14,
          color: white,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  /* Google Login */
  Future<void> _gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    Utils.showProgress(context, prDialog);

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');

      /* Save PhotoUrl in File */
      mProfileImg =
          await Utils.saveImageInStorage(userCredential.user?.photoURL ?? "");
      debugPrint('mProfileImg :===> $mProfileImg');

      checkAndNavigate(user.email, user.displayName ?? "", "2");
    } on FirebaseAuthException catch (e) {
      debugPrint('Exp ===> ${e.code.toString()}');
      debugPrint('Exp ===> ${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
      } else if (e.code == 'wrong-password') {
        // Hide Progress Dialog
        await prDialog.hide();
        debugPrint('Wrong password provided.');
        Utils.showToast('Wrong password provided.');
      } else {
        // Hide Progress Dialog
        await prDialog.hide();
      }
    }
  }

  checkAndNavigate(String mail, String displayName, String type) async {
    email = mail;
    userName = displayName;
    strType = type;
    debugPrint('checkAndNavigate email ==>> $email');
    debugPrint('checkAndNavigate userName ==>> $userName');
    debugPrint('checkAndNavigate strType ==>> $strType');
    debugPrint('checkAndNavigate mProfileImg :===> $mProfileImg');
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    try {
      await generalProvider.loginWithSocial(
          email, userName, strType, mProfileImg);
    } catch (e) {
      debugPrint("loginWithOTP Exception => $e");
      prDialog.hide();
    }
    debugPrint('checkAndNavigate loading ==>> ${generalProvider.loading}');

    if (!generalProvider.loading) {
      if (generalProvider.loginGmailModel.status == 200) {
        debugPrint(
            'loginGmailModel ==>> ${generalProvider.loginGmailModel.toString()}');
        debugPrint('Login Successfull!');
        Utils.saveUserCreds(
          userID: generalProvider.loginGmailModel.result?[0].id.toString(),
          userName: generalProvider.loginGmailModel.result?[0].name.toString(),
          userEmail:
              generalProvider.loginGmailModel.result?[0].email.toString(),
          userMobile:
              generalProvider.loginGmailModel.result?[0].mobile.toString(),
          userImage:
              generalProvider.loginGmailModel.result?[0].image.toString(),
          userPremium:
              generalProvider.loginGmailModel.result?[0].isBuy.toString(),
          userType: generalProvider.loginGmailModel.result?[0].type.toString(),
        );

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginGmailModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        await homeProvider.setSelectedTab(0);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1");

        // Hide Progress Dialog
        prDialog.hide();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Home(pageName: '')),
          (Route<dynamic> route) => false,
        );
      } else {
        // Hide Progress Dialog
        prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(context, "fail",
            "${generalProvider.loginGmailModel.message}", false);
      }
    }
  }
}
