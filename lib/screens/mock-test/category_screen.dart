import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/question_controller.dart';
import 'package:vnrdn_tai/models/Category.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/choose_mode_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/quiz_screen.dart';
import 'package:vnrdn_tai/screens/mock-test/test_set_screen.dart';
import 'package:vnrdn_tai/services/TestCategoryService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<TestCategory>> categories;

  getScreen(GlobalController gc, String categoryName, String categoryId) {
    QuestionController qc = Get.put(QuestionController());
    qc.updateTestCategoryId(categoryId);
    qc.updateTestCategoryName(categoryName);
    gc.updateTab(TABS.MOCK_TEST);
    // if (gc.test_mode.value == TEST_TYPE.STUDY) {
    //   Get.to(() => TestSetScreen(
    //         categoryName: categoryName,
    //         categoryId: categoryId,
    //       ));
    // } else {
    //   Get.to(() => QuizScreen(
    //         categoryId: categoryId,
    //       ));
    // }
  }

  getThumbnail(String categoryName) {
    String res = "";
    switch (categoryName) {
      case 'A1':
        res = "scooter";
        break;
      case 'A2':
        res = "motorcycle";
        break;
      case 'B1, B2':
        res = "car";
        break;
    }
    return res;
  }

  getQuestioNo(String categoryName) {
    String res = "";
    switch (categoryName) {
      case 'A1':
        res = "200 câu";
        break;
      case 'A2':
        res = "200 câu";
        break;
      case 'B1, B2':
        res = "600 câu";
        break;
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    categories = TestCategoryService().GetTestCategories();
  }

  @override
  Widget build(BuildContext context) {
    GlobalController gc = Get.find<GlobalController>();
    return Scaffold(
      body: FutureBuilder<List<TestCategory>>(
        key: UniqueKey(),
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
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
              return Stack(
                children: [
                  SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Chọn GPLX',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.blueAccent.shade200,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: kDefaultPaddingValue),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: kDefaultPaddingValue * 1.5),
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () {
                                    getScreen(gc, snapshot.data![index].name,
                                        snapshot.data![index].id);
                                  },
                                  style: kDefaultButtonStyle,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/quiz/${getThumbnail(snapshot.data![index].name)}.png",
                                        scale: 6,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: kDefaultPaddingValue * 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            gc.test_mode.value ==
                                                    TEST_TYPE.STUDY
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      "${getQuestioNo(snapshot.data![index].name)}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 16),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              );
            }
          }
        },
      ),
    );
  }
}
