import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/screens/mock-test/score_screen.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  Future<void> confirmSubmission(BuildContext context) async {
    DialogUtil.showAwesomeDialog(
        context,
        DialogType.info,
        "Nộp bài",
        "Bạn có chắc là muốn nộp bài? \n Bài thi trống sẽ không được lưu",
        () => Get.to(ScoreScreen()),
        () {});
  }

  Future<void> submit(BuildContext context) async {
    Get.to(ScoreScreen());
  }

  @override
  Widget build(BuildContext context) {
    QuestionController qc = Get.find<QuestionController>();
    int _quizTime = qc.testCategoryName.contains('B1') ? quizTimeB1 : quizTime;

    return GetBuilder<QuestionController>(
        init: qc,
        builder: (controller) {
          controller.runTimer();
          if (controller.animation.value == 1.0) {
            Future.delayed(Duration.zero, () async {
              submit(context);
            });
          }
          return WillPopScope(
            onWillPop: () async {
              return await true;
            },
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 66.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(50)),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          LayoutBuilder(
                            builder: (ctx, constraint) => Container(
                              // margin: EdgeInsets.only(
                              //   top: (constraint.maxHeight -
                              //                   constraint.maxHeight *
                              //                       controller.animation.value *
                              //                       (_quizTime / 48)) /
                              //               2 >
                              //           0
                              //       ? (constraint.maxHeight -
                              //               constraint.maxHeight *
                              //                   controller.animation.value *
                              //                   (_quizTime / 48)) /
                              //           2
                              //       : 0,
                              // ),
                              // margin: const EdgeInsets.symmetric(horizontal: 3),
                              alignment: Alignment.centerLeft,
                              width: constraint.maxWidth *
                                  controller.animation.value,
                              height: constraint.maxHeight *
                                          (controller.animation.value *
                                                  (_quizTime / 60) -
                                              controller.animation.value *
                                                  3.14) <
                                      constraint.maxHeight
                                  ? constraint.maxHeight *
                                      (controller.animation.value *
                                              (_quizTime / 60) -
                                          controller.animation.value * 3.14)
                                  : constraint.maxHeight,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 255, 61, 2),
                                    Color.fromARGB(255, 86, 176, 250),
                                    Color.fromARGB(255, 86, 176, 250),
                                    Color.fromARGB(255, 86, 176, 250),
                                    Color.fromARGB(255, 86, 176, 250),
                                    Color.fromARGB(255, 86, 176, 250),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Còn lại ${(_quizTime - controller.animation.value * _quizTime).round() < 60 ? '${(_quizTime - controller.animation.value * _quizTime).round()} giây' : '${((_quizTime - controller.animation.value * _quizTime) / 60).round()} phút'}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const FaIcon(
                                    FontAwesomeIcons.clock,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 66.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                    strokeAlign: StrokeAlign.outside),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ButtonTheme(
                      child: ElevatedButton(
                        onPressed: () {
                          confirmSubmission(context);
                        },
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                fontSize: FONTSIZES.textPrimary),
                            backgroundColor: Colors.blueAccent,
                            shadowColor: Colors.grey,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Nộp bài",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        });
  }
}
