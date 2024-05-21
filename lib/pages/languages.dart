// ignore_for_file: unused_field

import 'package:dtlive/utils/color.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:sidebarx/sidebarx.dart';

class Languages extends StatefulWidget {
  const Languages({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          padding: const EdgeInsets.all(23),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      color: white,
                      text: "changelanguage",
                      multilanguage: true,
                      textalign: TextAlign.start,
                      fontsizeNormal: 18,
                      fontsizeWeb: 18,
                      fontweight: FontWeight.w700,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 3),
                    MyText(
                      color: white,
                      text: "selectyourlanguage",
                      multilanguage: true,
                      textalign: TextAlign.start,
                      fontsizeNormal: 14,
                      fontsizeWeb: 14,
                      fontweight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    )
                  ],
                ),
              ),

              /* English */
              Expanded(
                child: StatefulBuilder(
                  builder: (BuildContext context, state) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildLanguage(
                            langName: "English",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('en');
                              Navigator.pop(context);
                            },
                          ),

                          /* Afrikaans */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Afrikaans",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('af');
                              Navigator.pop(context);
                            },
                          ),

                          /* Arabic */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Arabic",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('ar');
                              Navigator.pop(context);
                            },
                          ),

                          /* German */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "German",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('de');
                              Navigator.pop(context);
                            },
                          ),

                          /* Spanish */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Spanish",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('es');
                              Navigator.pop(context);
                            },
                          ),

                          /* French */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "French",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('fr');
                              Navigator.pop(context);
                            },
                          ),

                          /* Gujarati */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Gujarati",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('gu');
                              Navigator.pop(context);
                            },
                          ),

                          /* Hindi */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Hindi",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('hi');
                              Navigator.pop(context);
                            },
                          ),

                          /* Indonesian */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Indonesian",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('id');
                              Navigator.pop(context);
                            },
                          ),

                          /* Dutch */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Dutch",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('nl');
                              Navigator.pop(context);
                            },
                          ),

                          /* Portuguese (Brazil) */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Portuguese (Brazil)",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('pt');
                              Navigator.pop(context);
                            },
                          ),

                          /* Albanian */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Albanian",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('sq');
                              Navigator.pop(context);
                            },
                          ),

                          /* Turkish */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Turkish",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('tr');
                              Navigator.pop(context);
                            },
                          ),

                          /* Vietnamese */
                          const SizedBox(height: 20),
                          _buildLanguage(
                            langName: "Vietnamese",
                            onClick: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('vi');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguage({
    required String langName,
    required Function() onClick,
  }) {
    return FocusBase(
      onPressed: onClick,
      focusColor: white.withOpacity(0.7),
      onFocus: (isFocused) {},
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        height: 48,
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryLight,
            width: .5,
          ),
          color: colorPrimaryDark,
          borderRadius: BorderRadius.circular(5),
        ),
        child: MyText(
          color: white,
          text: langName,
          textalign: TextAlign.center,
          fontsizeNormal: 16,
          fontsizeWeb: 16,
          multilanguage: false,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          fontweight: FontWeight.w500,
          fontstyle: FontStyle.normal,
        ),
      ),
    );
  }
}
