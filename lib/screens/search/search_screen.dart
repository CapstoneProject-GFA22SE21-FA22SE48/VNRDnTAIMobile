import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/Keyword.dart';
import 'package:vnrdn_tai/screens/search/components/search_bar.dart';
import 'package:vnrdn_tai/services/KeywordService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Keyword>> keywords = KeywordSerivce().GetKeywordList();
  final List<IconData> iconData = <IconData>[
    Icons.dangerous_outlined,
    Icons.turn_right,
    Icons.perm_device_info,
    Icons.speed,
    Icons.fire_truck,
    Icons.local_parking,
    Icons.swap_vert,
    Icons.train,
    Icons.shop,
    Icons.invert_colors,
    Icons.style,
    Icons.ice_skating
  ];
  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    gc.updateQuery(null);
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: FutureBuilder<List<Keyword>>(
              key: UniqueKey(),
              future: keywords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingScreen();
                } else {
                  if (snapshot.hasError) {
                    Future.delayed(
                        Duration.zero,
                        () => {
                              handleError(snapshot.error
                                  ?.toString()
                                  .replaceFirst('Exception:', ''))
                            });
                    throw Exception(snapshot.error);
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SearchBar(),
                          const Divider(
                            indent: kDefaultPaddingValue,
                            endIndent: kDefaultPaddingValue,
                            color: Colors.blueAccent,
                            thickness: 3,
                            // height: kDefaultPaddingValue * 4,
                          ),
                          SizedBox(
                            width: 100.w,
                            height: 66.h,
                            child: GridView.count(
                              clipBehavior: Clip.hardEdge,
                              crossAxisCount: 2,
                              children: List.generate(
                                snapshot.data!.length,
                                (index) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        shadowColor: Colors.grey,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            iconSize: 48,
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            onPressed: () {},
                                            // color: Colors.accents[index],
                                            color: Colors.blueAccent,
                                            icon: Icon(iconData[index]),
                                          ),
                                          Text(
                                            snapshot.data![index].name,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: FONTSIZES.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                growable: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }),
        ));
  }
}
