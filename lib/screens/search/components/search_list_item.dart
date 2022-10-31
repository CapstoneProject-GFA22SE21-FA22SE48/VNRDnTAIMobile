import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/searchLawDTO.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_detail.dart';
import 'package:vnrdn_tai/screens/search/law/search_law_screen.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_detail.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:sizer/sizer.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({super.key, this.searchLawDto, this.searchSignDTO});
  final SearchLawDTO? searchLawDto;
  final SearchSignDTO? searchSignDTO;

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: "");
    var min = "";
    var max = "";
    if (searchLawDto != null) {
      min = numberFormat.format(double.parse(searchLawDto!.minPenalty));
      max = numberFormat.format(double.parse(searchLawDto!.maxPenalty));
    }

    if (searchLawDto != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => SearchLawDetailScreen(searchLawDto: searchLawDto),
                preventDuplicates: false);
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 16.w,
                    child: Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.black54,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPaddingValue),
                  child: Container(
                      width: 66.w,
                      padding: EdgeInsets.symmetric(
                        vertical: kDefaultPaddingValue / 4,
                        horizontal: kDefaultPaddingValue / 2,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                searchLawDto!.paragraphDesc != ""
                                    ? '${searchLawDto!.paragraphDesc!.replaceAll('\\', '')}'
                                    : '${searchLawDto!.sectionDesc}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: FONTSIZES.textPrimary)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: kDefaultPaddingValue / 2),
                              child: (searchLawDto!.minPenalty != "0" &&
                                      searchLawDto!.maxPenalty != "0")
                                  ? Text('Phạt tiền từ ${min}đến ${max} đồng',
                                      style: TextStyle(color: Colors.red))
                                  : const Text('Phạt cảnh cáo',
                                      style: TextStyle(color: Colors.red)),
                            ),
                            searchLawDto!.referenceParagraph!.isNotEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        top: kDefaultPaddingValue / 2),
                                    child: Text(
                                      'Tìm hiểu các hành vi liên quan',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                : Container(),
                          ])),
                ),
              ]),
        ),
      );
    } else if (searchSignDTO != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => SearchSignDetailScreen(searchSignDto: searchSignDTO));
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 25.w,
                    child: searchSignDTO!.imageUrl != null
                        ? Image.network(
                            searchSignDTO!.imageUrl as String,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.search,
                            size: 64,
                            color: Colors.black54,
                          )),
                Padding(
                  padding: const EdgeInsets.only(left: kDefaultPaddingValue),
                  child: Container(
                      width: 60.w,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                searchSignDTO!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: FONTSIZES.textMediumLarge)),
                            Text(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                searchSignDTO!.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontSize: FONTSIZES.textPrimary)),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: kDefaultPaddingValue / 2),
                              child: Text(
                                'Tìm hiểu thêm',
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ])),
                ),
              ]),
        ),
      );
    } else {
      return WillPopScope(
          onWillPop: () async {
            Get.to(() => ContainerScreen());
            return await true;
          },
          child: Container());
    }
  }
}
