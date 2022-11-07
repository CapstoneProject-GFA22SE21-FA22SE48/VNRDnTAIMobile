import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/location_util.dart';

class FeedbacksScreen extends StatefulWidget {
  FeedbacksScreen({
    super.key,
    this.type = '',
    this.sign,
  });

  String type;
  GPSSign? sign;

  @override
  State<StatefulWidget> createState() => _FeedbackClassState();
}

class _FeedbackClassState extends State<FeedbacksScreen> {
  final List<DropdownMenuItem<String>> _listDropdown =
      <DropdownMenuItem<String>>[
    const DropdownMenuItem<String>(
      value: "noSignHere",
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: "Tôi không thấy biển báo ở đây") //nhưng bản đồ hiển thị
        ]),
      ),
    ),
    const DropdownMenuItem<String>(
      value: "hasSignHere",
      child: Text("Biển báo ở đây nhưng bản đồ không hiển thị",
          overflow: TextOverflow.ellipsis),
    ),
    const DropdownMenuItem<String>(
      value: "wrongSign",
      child: Text("Biển báo không giống như trên bản đồ",
          overflow: TextOverflow.ellipsis),
    ),
  ];
  dynamic reason;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  String getTitle(String type) {
    switch (type) {
      case "gpsSign":
        return "Vị trí biển báo";
      case "sign":
        return "Thông tin biển báo";
      default:
        return "Luật";
    }
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadImage() async {
    GlobalController gc = Get.put(GlobalController());
    final path = 'user-feedbacks/${gc.userId.value}_${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      MapsController mapsController = Get.put(MapsController());

      mapsController.location.getLocation().then((location) {
        // switch (reason) {
        //   case "noSignHere":
        //     break;
        //   case "hasSignHere":
        //     break;
        //   case "wrongSign":
        //     break;
        // }

        GPSSignService()
            .AddGpsSign(
          LocationUtil.nearestSign([]),
          location.latitude!,
          location.longitude!,
        )
            .then((newSign) {
          FeedbackService()
              .createGpsSignsModificationRequest(
            reason,
            url,
            widget.sign,
            newSign,
          )
              .then((value) {
            print(value);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: const Text('Phản hồi thông tin'),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: 90.h,
              width: 100.w,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPaddingValue,
                vertical: kDefaultPaddingValue,
              ),
              color: Colors.white70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FONTSIZES.textHuge,
                    ),
                  ),
                  const Text(
                    'Nguyên nhân:',
                    style: TextStyle(
                      fontSize: FONTSIZES.textPrimary,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  DropdownButtonHideUnderline(
                    child: GFDropdown(
                      hint: const Text('Hãy chọn nguyên nhân'),
                      padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                      borderRadius: BorderRadius.circular(5),
                      border: const BorderSide(color: Colors.grey, width: 1),
                      dropdownButtonColor: Colors.white,
                      value: reason,
                      onChanged: (newValue) {
                        setState(() {
                          reason = newValue ?? '';
                        });
                      },
                      items: _listDropdown,
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(height: kDefaultPaddingValue),
                  Row(
                    children: [
                      const Text(
                        'Hình ảnh chứng minh:',
                        style: TextStyle(
                          fontSize: FONTSIZES.textPrimary,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: selectImage,
                        child: const Text('Tải lên'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                    width: 100.w,
                    child: pickedFile != null
                        ? Expanded(
                            child: Container(
                              height: 15.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  kDefaultPaddingValue / 2,
                                ),
                              ),
                              child: Center(
                                child: Image.file(
                                  File(pickedFile!.path!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 10.h,
                            width: 100.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                kDefaultPaddingValue / 2,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: kDefaultPaddingValue,
                  ),
                  ElevatedButton(
                    onPressed: uploadImage,
                    child: Padding(
                      padding: EdgeInsets.all((kDefaultPaddingValue / 8).h),
                      child: const Text('Gửi phản hồi'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
