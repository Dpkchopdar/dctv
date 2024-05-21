// ignore_for_file: unused_field

import 'package:dtlive/pages/home.dart';
import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<OTPVerify> createState() => OTPVerifyState();
}

class OTPVerifyState extends State<OTPVerify> {
  String mobileNumber = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ProgressDialog prDialog;
  SharedPre sharePref = SharedPre();
  final pinPutController = TextEditingController();
  String? verificationId, strDeviceToken = "", strDeviceType = "1";
  int? forceResendingToken;
  bool codeResended = false;

  @override
  void initState() {
    mobileNumber = Constant.otpMobileNumber;
    super.initState();
    _getDeviceToken();
    prDialog = ProgressDialog(context);
    codeSend(false);
  }

  _getDeviceToken() async {
    try {
      strDeviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("FirebaseMessaging Exception ===> $e");
    }
    debugPrint("strDeviceToken ===> $strDeviceToken");
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    pinPutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: Center(
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  MyText(
                    color: white,
                    text: "verifyphonenumber",
                    fontsizeNormal: 22,
                    fontsizeWeb: 18,
                    multilanguage: true,
                    fontweight: FontWeight.bold,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    color: otherColor,
                    text: "code_sent_desc",
                    fontsizeNormal: 15,
                    fontsizeWeb: 14,
                    fontweight: FontWeight.w500,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    multilanguage: true,
                    fontstyle: FontStyle.normal,
                  ),
                  MyText(
                    color: otherColor,
                    text: mobileNumber,
                    fontsizeNormal: 15,
                    fontsizeWeb: 14,
                    fontweight: FontWeight.w500,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    multilanguage: false,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 40),

                  /* Enter Received OTP */
                  Pinput(
                    length: 6,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: pinPutController,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorPrimary, width: 0.7),
                        shape: BoxShape.rectangle,
                        color: edtBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: GoogleFonts.montserrat(
                        color: white,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /* Confirm Button */
                  FocusBase(
                    focusColor: white,
                    onFocus: (isFocused) {},
                    onPressed: () {
                      debugPrint(
                          "Clicked sms Code =====> ${pinPutController.text}");
                      if (pinPutController.text.toString().isEmpty) {
                        Utils.showSnackbar(
                            context, "info", "enterreceivedotp", true);
                      } else {
                        Utils.showProgress(context, prDialog);
                        _checkOTPAndLogin();
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
                        text: "confirm",
                        fontsizeNormal: 17,
                        fontsizeWeb: 17,
                        multilanguage: true,
                        fontweight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  /* Resend */
                  FocusBase(
                    focusColor: gray.withOpacity(0.5),
                    onFocus: (isFocused) {},
                    onPressed: () {
                      if (!codeResended) {
                        codeSend(true);
                      }
                    },
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 70),
                      padding: const EdgeInsets.all(5),
                      child: MyText(
                        color: white,
                        text: "resend",
                        multilanguage: true,
                        fontsizeNormal: 15,
                        fontsizeWeb: 16,
                        fontweight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  codeSend(bool isResend) async {
    codeResended = isResend;
    await phoneSignIn(phoneNumber: mobileNumber.toString());
    prDialog.hide();
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    debugPrint("verification completed ======> ${authCredential.smsCode}");
    setState(() {
      pinPutController.text = authCredential.smsCode ?? "";
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      debugPrint("The phone number entered is invalid!");
      Utils.showSnackbar(context, "fail", "invalidphonenumber", true);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    debugPrint("verificationId =======> $verificationId");
    debugPrint("resendingToken =======> ${forceResendingToken.toString()}");
    debugPrint("code sent");
  }

  _onCodeTimeout(String verificationId) {
    debugPrint("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    prDialog.hide();
    codeResended = false;
    return null;
  }

  _checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    debugPrint("_checkOTPAndLogin verificationId =====> $verificationId");
    debugPrint("_checkOTPAndLogin smsCode =====> ${pinPutController.text}");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: pinPutController.text.toString(),
    );

    debugPrint(
        "phoneAuthCredential.smsCode        =====> ${phoneAuthCredential.smsCode}");
    debugPrint(
        "phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      debugPrint(
          "_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      await prDialog.hide();
      debugPrint("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "otp_invalid", true);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "otp_session_expired", true);
        return;
      } else {
        error = true;
      }
    }
    debugPrint(
        "Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      _login(mobileNumber.toString());
    } else {
      await prDialog.hide();
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "otp_login_fail", true);
    }
  }

  _login(String mobile) async {
    debugPrint("click on Submit mobile => $mobile");
    var generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    try {
      await generalProvider.loginWithOTP(mobile);
    } catch (e) {
      debugPrint("loginWithOTP Exception => $e");
      prDialog.hide();
    }

    if (!generalProvider.loading) {
      if (generalProvider.loginOTPModel.status == 200) {
        debugPrint(
            'loginOTPModel ==>> ${generalProvider.loginOTPModel.toString()}');
        debugPrint('Login Successfull!');
        Utils.saveUserCreds(
          userID: generalProvider.loginOTPModel.result?[0].id.toString(),
          userName: generalProvider.loginOTPModel.result?[0].name.toString(),
          userEmail: generalProvider.loginOTPModel.result?[0].email.toString(),
          userMobile:
              generalProvider.loginOTPModel.result?[0].mobile.toString(),
          userImage: generalProvider.loginOTPModel.result?[0].image.toString(),
          userPremium:
              generalProvider.loginOTPModel.result?[0].isBuy.toString(),
          userType: generalProvider.loginOTPModel.result?[0].type.toString(),
        );

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginOTPModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        await homeProvider.setLoading(true);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1");

        prDialog.hide();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Home(pageName: '')),
          (Route<dynamic> route) => false,
        );
      } else {
        prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginOTPModel.message}", false);
      }
    }
  }
}
