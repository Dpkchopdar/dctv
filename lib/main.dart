import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dtlive/firebase_options.dart';
import 'package:dtlive/pages/home.dart';
import 'package:dtlive/pages/splash.dart';
import 'package:dtlive/provider/channelsectionprovider.dart';
import 'package:dtlive/provider/episodeprovider.dart';
import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/paymentprovider.dart';
import 'package:dtlive/provider/playerprovider.dart';
import 'package:dtlive/provider/profileprovider.dart';
import 'package:dtlive/provider/rentstoreprovider.dart';
import 'package:dtlive/provider/searchprovider.dart';
import 'package:dtlive/provider/sectionbytypeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/provider/showdetailsprovider.dart';
import 'package:dtlive/provider/subscriptionprovider.dart';
import 'package:dtlive/provider/videobyidprovider.dart';
import 'package:dtlive/provider/videodetailsprovider.dart';
import 'package:dtlive/provider/watchlistprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Locales.init(['en', 'ar', 'hi']);

  if (!kIsWeb) {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(Constant.oneSignalAppId);
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint("Accepted permission : $state");
    });
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GeneralProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => PlayerProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => RentStoreProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => SectionByTypeProvider()),
          ChangeNotifierProvider(create: (_) => SectionDataProvider()),
          ChangeNotifierProvider(create: (_) => ChannelSectionProvider()),
          ChangeNotifierProvider(create: (_) => ShowDetailsProvider()),
          ChangeNotifierProvider(create: (_) => EpisodeProvider()),
          ChangeNotifierProvider(create: (_) => VideoByIDProvider()),
          ChangeNotifierProvider(create: (_) => VideoDetailsProvider()),
          ChangeNotifierProvider(create: (_) => WatchlistProvider()),
          ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HomeProvider homeProvider;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _getDeviceInfo();
    if (!kIsWeb) {
      OneSignal.Notifications.addForegroundWillDisplayListener(
          _handleForgroundNotification);
    }
    super.initState();
  }

  _handleForgroundNotification(OSNotificationWillDisplayEvent event) async {
    final notification = event.notification;
    debugPrint("Notification title :===> ${notification.title}");
    debugPrint("Notification body  :===> ${notification.body}");
    debugPrint("Notification Data  :===> ${notification.additionalData}");

    /// preventDefault to not display the notification
    event.preventDefault();

    /// Do async work
    /// notification.display() to display after preventing default
    event.notification.display();

    if (notification.additionalData != null) {
      if (notification.additionalData?['user_id'] != null) {
        Utils.setUserId(notification.additionalData?['user_id'].toString());
        Constant.userID = notification.additionalData?['user_id'].toString();
        debugPrint("userID :====MAIN====> ${Constant.userID}");
        await homeProvider.updateSideMenu();
        if (!mounted) return;
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const Home(pageName: '')),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: colorPrimary,
          primaryColorDark: colorPrimaryDark,
          primaryColorLight: primaryLight,
          scaffoldBackgroundColor: appBgColor,
        ).copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(white),
            trackVisibility: MaterialStateProperty.all(true),
            trackColor: MaterialStateProperty.all(whiteTransparent),
          ),
        ),
        title: Constant.appName ?? "",
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          return locale;
        },
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 360, name: MOBILE),
              const Breakpoint(start: 361, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1000, name: DESKTOP),
              const Breakpoint(start: 1001, end: double.infinity, name: '4K'),
            ],
          );
        },
        home: const Splash(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
            PointerDeviceKind.trackpad
          },
        ),
      ),
    );
  }

  _getDeviceInfo() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Constant.isTV =
          androidInfo.systemFeatures.contains('android.software.leanback');
      debugPrint("isTV =======================> ${Constant.isTV}");
    }
  }
}
