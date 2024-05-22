import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/widget/mypagebuilder.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
//---------------YMG Popup------------------//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final String? pageName;
  const Home({Key? key, required this.pageName}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late HomeProvider homeProvider;
  late SectionDataProvider sectionDataProvider;
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPre sharedPref = SharedPre();
  String? currentPage;

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    currentPage = widget.pageName ?? "";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopupDialog();
      _getData();
    });
    if (!kIsWeb) {
      OneSignal.Notifications.addClickListener(_handleNotificationOpened);
    }
  }

  void _showPopupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(); // Use the CustomDialog widget here
      },
    );
  }

  // What to do when the user opens/taps on a notification
  _handleNotificationOpened(OSNotificationClickEvent result) async {
    /* id, video_type, type_id, user_id */
    debugPrint(
        "setNotificationOpenedHandler additionalData ===> ${result.notification.additionalData.toString()}");
    debugPrint(
        "setNotificationOpenedHandler user_id ===> ${result.notification.additionalData?['user_id']}");
    if (result.notification.additionalData != null &&
        result.notification.additionalData?['user_id'] != null) {
      Utils.setUserId(
          result.notification.additionalData?['user_id'].toString());
      Constant.userID =
          result.notification.additionalData?['user_id'].toString();
      await homeProvider.updateSideMenu();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const Home(pageName: '')),
        (Route<dynamic> route) => false,
      );
    }

    debugPrint(
        "setNotificationOpenedHandler video_id ===> ${result.notification.additionalData?['id']}");
    debugPrint(
        "setNotificationOpenedHandler upcoming_type ===> ${result.notification.additionalData?['upcoming_type']}");
    debugPrint(
        "setNotificationOpenedHandler video_type ===> ${result.notification.additionalData?['video_type']}");
    debugPrint(
        "setNotificationOpenedHandler type_id ===> ${result.notification.additionalData?['type_id']}");

    if (result.notification.additionalData != null &&
        result.notification.additionalData?['id'] != null &&
        result.notification.additionalData?['upcoming_type'] != null &&
        result.notification.additionalData?['video_type'] != null &&
        result.notification.additionalData?['type_id'] != null) {
      String? videoID =
          result.notification.additionalData?['id'].toString() ?? "";
      String? upcomingType =
          result.notification.additionalData?['upcoming_type'].toString() ?? "";
      String? videoType =
          result.notification.additionalData?['video_type'].toString() ?? "";
      String? typeID =
          result.notification.additionalData?['type_id'].toString() ?? "";
      debugPrint("videoID =======> $videoID");
      debugPrint("upcomingType ==> $upcomingType");
      debugPrint("videoType =====> $videoType");
      debugPrint("typeID ========> $typeID");

      _controller.selectIndex(0);
      if (!mounted) return;
      Utils.openDetails(
        context: context,
        controller: _controller,
        videoId: int.parse(videoID),
        upcomingType: int.parse(upcomingType),
        videoType: int.parse(videoType),
        typeId: int.parse(typeID),
      );
    }
  }

  _getData() async {
    Utils.getCurrencySymbol();
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    Constant.userID = await sharedPref.read("userid");
    debugPrint("userID :====HOME====> ${Constant.userID}");
    await homeProvider.setLoading(true);
    await homeProvider.getSectionType();

    if (!homeProvider.loading) {
      if (homeProvider.sectionTypeModel.status == 200 &&
          homeProvider.sectionTypeModel.result != null) {
        if ((homeProvider.sectionTypeModel.result?.length ?? 0) > 0) {
          getTabData(0);
        }
      }
    }

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    generalProvider.getGeneralsetting();
  }

  Future<void> setSelectedTab(int tabPos) async {
    if (!mounted) return;
    await homeProvider.setSelectedTab(tabPos);
    debugPrint("setSelectedTab position ====> $tabPos");
    sectionDataProvider.setTabPosition(tabPos);
  }

  Future<void> getTabData(int position) async {
    await setSelectedTab(position);
    await sectionDataProvider.setLoading(true);
    await sectionDataProvider.getSectionBanner(
        position == 0
            ? "0"
            : (homeProvider.sectionTypeModel.result?[position - 1].id),
        position == 0 ? "1" : "2");
    await sectionDataProvider.getSectionList(
        position == 0
            ? "0"
            : (homeProvider.sectionTypeModel.result?[position - 1].id),
        position == 0 ? "1" : "2");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: Row(
          children: [
            SideMenu(controller: _controller),
            Expanded(
              child: Center(
                child: MyPageBuilder(
                  controller: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ========= YMG popup code ========= */

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the data is still being fetched, show an empty container
          return Container();
        } else if (snapshot.hasError) {
          // If there's an error during data fetching, show an error message
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data as Map<String, dynamic>;

          if (data['dialog'] == 'on') {
            // If "dialog" value is "on", show the dialog

            final appVersion = "1.3.0"; // Replace with your actual app version
            final dialogVersion = data['version'] ?? "1.3.0";

            if (appVersion != dialogVersion) {
              return Dialog(
                backgroundColor: Colors.grey[900], // Dark gray background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 16,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Heading Text from API
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              data['heading'] ?? 'Default Heading',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (data['image'] != null && data['image'].isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                data['image'],
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                            ),

                          // Content Text from API
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16,
                                top: 8.0), // Adjust the left padding as needed
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                data['content'] ?? '',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8), // Adjust the height as needed
                          // Image below the text

                          SizedBox(height: 16),
                          // Button
                          ElevatedButton(
                            onPressed: () async {
                              // Close the dialog
                              Navigator.of(context).pop();

                              // Launch the URL in the browser
                              final url = data['url'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              data['contenta'] ?? 'Update Now',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: colorPrimary, // Accent color
                              fixedSize: Size(250, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // If "dialog" value is not "on", you can return an empty widget or null
              Navigator.pop(context); // Dismiss the dialog
              return SizedBox.shrink();
            }
          } else {
            // If "dialog" value is not "on", you can return an empty widget or null
            Navigator.pop(context); // Dismiss the dialog
            return SizedBox.shrink();
          }
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://dcplay.in/ymg/custom/updater_pop-up/androidtv.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
