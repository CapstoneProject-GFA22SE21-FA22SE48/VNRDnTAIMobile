import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/feedbacks/sign_content_feedback_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_screen.dart';
import 'package:vnrdn_tai/controllers/search_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/widgets/animation/ripple.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class AnalysisScreen extends StatelessWidget {
  AnalysisScreen({super.key});

  Widget getBoundingBoxes(List<dynamic> coords, double height, double width) {
    AnalysisController ac = Get.find<AnalysisController>();
    double xmin = double.parse(coords[1]) * width - width / 2;
    double ymin = double.parse(coords[2]) * height;
    double xmax = double.parse(coords[3]) * width - width / 2;
    double ymax = double.parse(coords[4]) * height;
    var name = 'here';
    // ac.mapData![int.parse(coords[0].replaceAll(".0", ""))].toString();
    // var ratioH = height / 240;
    // var ratioW = width / 320;
    // print(coords[0]);

    // double xmin = coords[1];
    // double ymin = coords[2];
    // double xmax = coords[3];
    // double ymax = coords[4];
    // var name = coords[0];

    return Positioned(
        left: xmin + width / 2,
        top: ymin,
        //left: xmin + (xmin * ratioW) / 2,
        //top: ymin + (ymin * ratioH) / 3.5,
        child: InkWell(
            onTap: () {
              SearchController sc = Get.put(SearchController());
              ac.stopImageStream();
              sc.updateQuery(name);
              sc.updateIsFromAnalysis(true);
              Get.offAll(() => ContainerScreen());
            },
            child: Container(
              alignment: Alignment.bottomLeft,
              width: xmax - xmin,
              height: ymax - ymin,
              // width: (xmax - xmin) * ratioW * 2,
              // height: (ymax - ymin) * ratioH,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.yellow[100]!,
                ),
              ),
              child: Text(
                'Biển $name',
                style: TextStyle(
                    backgroundColor: Colors.yellow[100],
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    AnalysisController ac = Get.put(AnalysisController());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Timer _timer = Timer(Duration(seconds: 10), () => ac.found);
    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: (() {
                  Get.offAll(() => const ContainerScreen());
                }),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              title: const Text(
                "Nhận diện biển báo",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
            ),
            body: !controller.isLoaded
                ? loadingScreen()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      // controller.imagePath == ""
                      // ?
                      AspectRatio(
                        aspectRatio:
                            controller.cameraController.value.aspectRatio,
                        child: CameraPreview(
                          controller.cameraController,
                        ),
                      )
                      // : Image.file(
                      //     io.File(controller.imagePath!),
                      //     fit: BoxFit.fill,
                      //     height: double.infinity,
                      //     width: double.infinity,
                      //     alignment: Alignment.center,
                      //   )
                      ,
                      controller.boxes == []
                          ? Container()
                          : Stack(children: <Widget>[
                              for (var box in controller.boxes)
                                getBoundingBoxes(box, height - 80, width)
                              // getBoundingBoxes(box, height, width)
                            ]),
                      Positioned(
                        bottom: 0.h,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: 30.h,
                          width: 15.h,
                          child: SizedBox(
                            width: 100.w,
                            height: 30.h,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15.h,
                                ),
                                FutureBuilder(
                                  key: UniqueKey(),
                                  initialData: _timer,
                                  builder: (context, snapshot) =>
                                      stillNotFound(context),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: kDefaultPaddingValue),
                                    child: controller.isDetecting
                                        ? Text('Đang tìm kiếm biển báo...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                        : controller.boxes.length > 0
                                            ? Text(
                                                ' Hệ thống đã nhận diện được ${controller.boxes.length} biển báo',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              )
                                            : Text(
                                                ' Bấm nút phía dưới để bắt đầu quét',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                  ),
                                ),
                                // controller.isDetecting
                                //     ? Center(
                                //         child: RippleAnimation(
                                //             minRadius: 100,
                                //             ripplesCount: 15,
                                //             repeat: controller.isDetecting,
                                //             color: Colors.white,
                                //             child: Padding(
                                //               padding: const EdgeInsets.only(
                                //                   top: 20, left: 18),
                                //               child: ElevatedButton(
                                //                   onPressed: () async {
                                //                     await controller
                                //                         .stopImageStream();
                                //                   },
                                //                   style: ElevatedButton.styleFrom(
                                //                       shape:
                                //                           const CircleBorder(),
                                //                       fixedSize:
                                //                           const Size(60, 60)),
                                //                   child: const Icon(Icons.stop,
                                //                       size: 32,
                                //                       color: Colors.red)),
                                //             )),
                                //       )
                                //     : Padding(
                                //         padding: const EdgeInsets.only(
                                //             top: 20, left: 18),
                                //         child: ElevatedButton(
                                //             onPressed: () async {
                                //               await controller
                                //                   .startImageStream();
                                //             },
                                //             style: ElevatedButton.styleFrom(
                                //                 shape: const CircleBorder(),
                                //                 fixedSize: const Size(60, 60)),
                                //             child: const Icon(Icons.play_arrow,
                                //                 size: 32)),
                                //       ),

                                // Padding(
                                //     padding: const EdgeInsets.only(
                                //         top: kDefaultPaddingValue),
                                //     child: Text('${controller.detected}',
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .headline5
                                //             ?.copyWith(
                                //                 color:
                                //                     Colors.blueAccent.shade200,
                                //                 fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: Container(
              width: 100.w,
              height: 15.h,
              alignment: Alignment.topCenter,
              child: controller.isLoaded && controller.isDetecting
                  ? Center(
                      child: RippleAnimation(
                          minRadius: 100,
                          ripplesCount: 15,
                          repeat: controller.isDetecting,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPaddingValue, left: 18),
                            child: ElevatedButton(
                                onPressed: () async {
                                  await controller.stopImageStream();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    fixedSize: const Size(60, 60)),
                                child: const Icon(Icons.stop,
                                    size: 32, color: Colors.red)),
                          )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: kDefaultPaddingValue, left: 18),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller.startImageStream();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              fixedSize: const Size(60, 60)),
                          child: const Icon(Icons.play_arrow, size: 32)),
                    ),
            ),
          );
        });
  }

  void handleFeedbackContent(BuildContext context) async {
    GlobalController gc = Get.put(GlobalController());
    if (gc.userId.value.isNotEmpty) {
      Get.to(() => const LoaderOverlay(
            child: SignContentFeedbackScreen(),
          ));
    } else {
      DialogUtil.showTextDialog(
        context,
        "Cảnh báo",
        "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
        [
          TemplatedButtons.yes(context, const LoginScreen()),
          TemplatedButtons.no(context),
        ],
      );
    }
  }

  Widget stillNotFound(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPaddingValue * 2.5),
          child: Text(
            'Không tìm thấy biển báo?',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                fontSize: FONTSIZES.textPrimary,
                color: Colors.blueAccent.shade200,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPaddingValue),
          child: ElevatedButton(
            onPressed: () => handleFeedbackContent(context),
            style: ElevatedButton.styleFrom(),
            child: Text(
              'Báo cáo ngay',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontSize: FONTSIZES.textMedium,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
