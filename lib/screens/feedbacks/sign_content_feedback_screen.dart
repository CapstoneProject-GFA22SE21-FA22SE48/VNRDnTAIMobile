import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/analysis_controller.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class SignContentFeedbackScreen extends StatelessWidget {
  const SignContentFeedbackScreen({super.key});

  Future uploadRom(AnalysisController ac) async {
    var pickedFile = ac.image;
    final path = 'user-feedbacks/SignContentFeedbacks/${pickedFile!.name}';
    final file = File(pickedFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    var uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    await snapshot.ref.getDownloadURL().then((url) {
      SignModificationRequest rom = new SignModificationRequest('', null, null,
          null, null, null, null, null, 3, url, 0, DateTime.now());
      FeedbackService().createSignsModificationRequest(rom);
    });
  }

  @override
  Widget build(BuildContext context) {
    AnalysisController ac = Get.put(AnalysisController());

    return GetBuilder<AnalysisController>(
        init: ac,
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Báo cáo sự cố"),
                actions: [
                  IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        ac.image != null
                            ? uploadRom(ac)
                            : Get.snackbar(
                                'Lưu ý', 'Vui lòng cung cấp hình ảnh trước',
                                colorText: Colors.blueGrey,
                                isDismissible: true);

                        // Get.to(() => CartPage(), preventDuplicates: false);
                      }),
                ],
              ),
              body: SafeArea(
                  child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Người dùng: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textLarge)),
                                ),
                                Text('Người dùng tự do',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textLarge)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Sự cố xảy ra lúc:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textLarge)),
                                ),
                                Text(
                                    '${DateFormat('hh:mm dd/MM/yyyy').format(DateTime.now())}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textLarge)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Chi tiết báo cáo:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textLarge)),
                                ),
                                Text('Không nhận diện\n được biển báo',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textLarge)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue),
                                  child: Text('Loại báo cáo:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textLarge)),
                                ),
                                Text('Lỗi ứng dụng',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: FONTSIZES.textLarge)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: kDefaultPaddingValue * 2),
                                  child: Text('',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: FONTSIZES.textLarge)),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: kDefaultPaddingValue,
                                    right: kDefaultPaddingValue / 2),
                                child: SizedBox(
                                  width: 50.w,
                                  height: 60.h,
                                  child: controller.imagePath == ""
                                      ? CameraPreview(
                                          controller.cameraController)
                                      : Image.file(
                                          File(controller.imagePath!),
                                          fit: BoxFit.fill,
                                          height: double.infinity,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPaddingValue * 2),
                        child: Text(
                            'Xin vui lòng lưu lại hình ảnh làm bằng chứng trước khi gửi phản hồi!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: FONTSIZES.textLarge)),
                      )
                    ],
                  ),
                  Positioned(
                    left: 65.w,
                    top: 50.h,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 18),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller.takeSignContentFeebackImage();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              fixedSize: const Size(50, 50)),
                          child: const Icon(Icons.camera_alt, size: 28)),
                    ),
                  ),
                  controller.imagePath != ""
                      ? Positioned(
                          right: 1.w,
                          top: 0.h,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 18),
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.clearFeedbackImage();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    fixedSize: const Size(30, 30)),
                                child: const Icon(Icons.clear, size: 28)),
                          ),
                        )
                      : Container(),
                ],
              )));
        });
  }
}