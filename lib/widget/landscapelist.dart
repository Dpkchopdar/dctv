import 'package:dtlive/model/sectionlistmodel.dart' as section;
import 'package:dtlive/model/channelsectionmodel.dart' as channel;
import 'package:dtlive/pages/tvvideosbyid.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class LandscapeList extends StatefulWidget {
  final dynamic sectionDataList;
  final int? sectionPos;
  final String? dataType, dataFrom;
  final int? typeId;
  const LandscapeList({
    Key? key,
    required this.sectionDataList,
    required this.sectionPos,
    required this.dataType,
    required this.dataFrom,
    required this.typeId,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<LandscapeList> createState() => _LandscapeListState();
}

class _LandscapeListState extends State<LandscapeList> {
  dynamic dataList = [];

  @override
  void initState() {
    debugPrint("dataFrom =========> ${widget.dataFrom}");
    if (widget.dataFrom == "Channel") {
      dataList = widget.sectionDataList as List<channel.Datum>?;
    } else {
      dataList = widget.sectionDataList as List<section.Datum>?;
    }
    super.initState();
  }

  openDetailPage(int dataPos, int videoId, int upcomingType, int videoType,
      int typeId) async {
    debugPrint("videoId ==========> $videoId");
    debugPrint("videoType ==========> $videoType");
    debugPrint("typeId ==========> $typeId");
    if (widget.dataType == "ByLanguage" || widget.dataType == "ByCategory") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TVVideosByID(
              dataList?[dataPos].id ?? 0,
              widget.typeId ?? 0,
              dataList?[dataPos].name ?? "",
              widget.dataType ?? "",
              controller: widget._controller,
            );
          },
        ),
      );
    } else {
      if (!mounted) return;
      Utils.openDetails(
        context: context,
        controller: widget._controller,
        videoId: videoId,
        upcomingType: upcomingType,
        videoType: videoType,
        typeId: typeId,
      );
    }
  }

  @override
  void dispose() {
    dataList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightLand,
      child: ListView.separated(
        itemCount: (dataList?.length ?? 0),
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return FocusBase(
            focusColor: white,
            onFocus: (isFocused) {},
            onPressed: () {
              debugPrint("Clicked on index ==> $index");
              openDetailPage(
                index,
                dataList?[index].id ?? 0,
                (widget.dataFrom != "Channel")
                    ? (dataList?[index].upcomingType ?? 0)
                    : 0,
                dataList?[index].videoType ?? 0,
                dataList?[index].typeId ?? 0,
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: Dimens.widthLand,
                  height: Dimens.heightLand,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.05),
                          child: MyNetworkImage(
                            imageUrl: (widget.dataType == "ByLanguage" ||
                                    widget.dataType == "ByCategory")
                                ? (dataList?[index].image.toString() ?? "")
                                : (dataList?[index].landscape.toString() ?? ""),
                            fit: BoxFit.cover,
                            imgHeight: MediaQuery.of(context).size.height,
                            imgWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        if (widget.dataType == "ByLanguage" ||
                            widget.dataType == "ByCategory")
                          Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            height: Dimens.heightLand,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  transparentColor,
                                  transparentColor,
                                  appBgColor,
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.dataType == "ByLanguage" ||
                    widget.dataType == "ByCategory")
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: MyText(
                      color: white,
                      text: dataList?[index].name.toString() ?? "",
                      textalign: TextAlign.start,
                      fontsizeNormal: 14,
                      fontweight: FontWeight.w600,
                      fontsizeWeb: 15,
                      multilanguage: false,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
