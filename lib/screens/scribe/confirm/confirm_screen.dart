import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/screens/scribe/list_rom/list_rom_screen.dart';
import 'package:vnrdn_tai/services/SignModificationRequestService.dart';
import 'package:vnrdn_tai/services/SignService.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/image_util.dart';

class ConfirmEvidenceScreen extends StatefulWidget {
  ConfirmEvidenceScreen({
    super.key,
    required this.romId,
    required this.imageUrl,
    required this.operationType,
  });

  String romId;
  String imageUrl;
  int operationType;

  @override
  State<StatefulWidget> createState() => _ConfirmEvidenceState();
}

class _ConfirmEvidenceState extends State<ConfirmEvidenceScreen> {
  final imagePicker = ImagePicker();
  final searchSignController = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  dynamic adminId;
  dynamic selectedSign;
  dynamic status;

  late List<DropdownMenuItem> _listDropdownSigns = [];
  late List<DropdownMenuItem> _listDropdownAdmin = [];
  late Future<List<SignCategoryDTO>> signCategories =
      SignService().GetSignCategoriesDTOList();

  final List<DropdownMenuItem<int>> _listDropdown = <DropdownMenuItem<int>>[
    const DropdownMenuItem<int>(
      value: 3,
      child: Text(
        "???? x??? l??",
      ),
    ),
    const DropdownMenuItem<int>(
      value: 4,
      child: Text(
        "???? t??? ch???i",
      ),
    ),
  ];

  void setSignDropdownList(List<SignCategoryDTO> categories) {
    for (var category in categories) {
      for (var sign in category.searchSignDTOs) {
        _listDropdownSigns.add(
          DropdownMenuItem(
            value: sign.name,
            child: Row(children: [
              CachedNetworkImage(
                imageUrl: sign.imageUrl as String,
                imageBuilder: (context, imageProvider) => Container(
                  width: 10.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child:
                      const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                ), //show progress  while loading image
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/alt_img.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPaddingValue),
                child: Text(sign.name.length > 33
                    ? '${sign.name.substring(0, 33)}...'
                    : sign.name),
              )
            ]),
          ),
        );
      }
    }
    setState(() {});
  }

  Color getColorByCategory(String name) {
    name = name.toLowerCase();
    if (name.contains('c???m')) {
      return kDangerButtonColor;
    } else if (name.contains('c???nh b??o')) {
      return kWarningButtonColor;
    } else if (name.contains('ch??? d???n')) {
      return kPrimaryButtonColor;
    } else if (name.contains('hi???u l???nh')) {
      return kBlueAccentBackground;
    } else {
      return kDisabledButtonColor;
    }
  }

  String getTitle(String type) {
    switch (type) {
      case "gpsSign":
        return "V??? tr?? bi???n b??o";
      case "sign":
        return "Th??ng tin bi???n b??o";
      default:
        return "Lu???t";
    }
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future captureImage() async {
    final captured = await imagePicker.getImage(source: ImageSource.camera);
    if (captured == null) return;

    setState(() {
      pickedFile = PlatformFile(
          name: captured.path.split('/').last,
          path: captured.path,
          size: 1024 * 1024 * 30);
    });
  }

  Future uploadImage(BuildContext context) async {
    context.loaderOverlay.show();
    GlobalController gc = Get.put(GlobalController());
    // final oldFile = widget.imageUrl.split('user-feedbacks/sign-position/').last;
    final ext = pickedFile!.name.split('.').last;
    final path =
        'user-feedbacks/sign-position/confirmed_${gc.userId.value}_${DateTime.now().toUtc()}.$ext';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((url) {
      SignModificationRequestService()
          .confirmEvidence(widget.romId, status, url.split('&token').first,
              adminId, selectedSign)
          .then((value) {
        if (value != null) {
          createNotification(value).then((sent) {
            context.loaderOverlay.hide();
            if (sent) {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.success,
                  "Th??nh c??ng",
                  "X??c nh???n th??nh c??ng!\nQuay v??? danh s??ch ph???n h???i",
                  () => Get.off(() => ListRomScreen()),
                  null);
            } else {
              DialogUtil.showAwesomeDialog(
                  context,
                  DialogType.error,
                  "X??c nh???n th???t b???i",
                  "C?? l???i x???y ra.\nVui l??ng ki???m tra l???i",
                  () {},
                  null);
            }
          });
        } else {
          context.loaderOverlay.hide();
          DialogUtil.showAwesomeDialog(
              context,
              DialogType.error,
              "X??c nh???n th???t b???i",
              "C?? l???i x???y ra.\nVui l??ng th??? l???i sau",
              () {},
              null);
        }
      });
    });
  }

  Future<bool> createNotification(SignModificationRequest rom) async {
    GlobalController gc = Get.put(GlobalController());
    DatabaseReference ref = FirebaseDatabase.instance.ref('notifications');

    String action = '';
    // name action
    switch (rom.operationType) {
      case 0:
        action = '????? xu???t th??m m???i';
        break;
      case 1:
        action = '????? xu???t ch???nh s???a';
        break;
      default:
        action = '????? xu???t lo???i b???';
    }

    await ref.push().set({
      "senderId": rom.scribeId,
      "senderUsername": gc.username.value,
      "receiverId": rom.adminId,
      "receiverUsername": _listDropdownAdmin
          .firstWhere((e) => e.value == rom.adminId)
          .child
          .toStringShort(),
      "subjectType": "GPSSign",
      "subjectId": rom.modifyingGpssignId,
      "relatedDescription": "GPS c???a bi???n s???...",
      "action": action,
      "createdDate": DateTime.now().toLocal().toString(),
      "isRead": false
    });
    return true;
  }

  @override
  void initState() {
    context.loaderOverlay.show();
    signCategories.then((list) => setSignDropdownList(list));
    UserService().getAdmins().then((list) {
      if (list.isNotEmpty) {
        list.forEach((element) {
          _listDropdownAdmin.add(DropdownMenuItem<String>(
            value: element.id,
            child: Text(element.displayName ?? element.username),
          ));
        });
      }
      setState(() {});
      context.loaderOverlay.hide();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: const Text('X??c nh???n ph???n h???i'),
      ),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return SingleChildScrollView(
            padding: kDefaultPadding,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'G???i y??u c???u t???i:',
                  style: TextStyle(
                    fontSize: FONTSIZES.textPrimary,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kDefaultPaddingValue / 2),
                DropdownButtonHideUnderline(
                  child: GFDropdown(
                    hint: const Text('Ch???n qu???n tr??? vi??n'),
                    padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                    borderRadius: BorderRadius.circular(5),
                    border: const BorderSide(color: Colors.grey, width: 1),
                    dropdownButtonColor: Colors.white,
                    value: adminId,
                    onChanged: (newValue) {
                      setState(() {
                        adminId = newValue ?? 3;
                      });
                    },
                    items: _listDropdownAdmin,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: kDefaultPaddingValue),
                const Text(
                  'Tr???ng th??i:',
                  style: TextStyle(
                    fontSize: FONTSIZES.textPrimary,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: kDefaultPaddingValue / 2),
                DropdownButtonHideUnderline(
                  child: GFDropdown(
                    hint: const Text('Ch???n tr???ng th??i x??? l??'),
                    padding: const EdgeInsets.all(kDefaultPaddingValue / 2),
                    borderRadius: BorderRadius.circular(5),
                    border: const BorderSide(color: Colors.grey, width: 1),
                    dropdownButtonColor: Colors.white,
                    value: status,
                    onChanged: (newValue) {
                      setState(() {
                        status = newValue ?? 3;
                      });
                    },
                    items: _listDropdown,
                    isExpanded: true,
                  ),
                ),
                widget.operationType != 2
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kDefaultPaddingValue),
                          const Text(
                            'Bi???n b??o:',
                            style: TextStyle(
                              fontSize: FONTSIZES.textPrimary,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: kDefaultPaddingValue / 2),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              buttonOverlayColor:
                                  MaterialStateProperty.all(Colors.white),
                              buttonPadding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddingValue / 2),
                              buttonDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              hint: const Text(
                                'Ch???n bi???n b??o',
                                style: TextStyle(
                                  fontSize: FONTSIZES.textPrimary,
                                  color: kDisabledTextColor,
                                ),
                              ),

                              items: _listDropdownSigns.isNotEmpty
                                  ? _listDropdownSigns.toList()
                                  : [
                                      DropdownMenuItem(
                                          alignment: Alignment.centerLeft,
                                          child: Transform.scale(
                                            scale: 0.6,
                                            child: loadingScreen(),
                                          ))
                                    ],
                              value: selectedSign,
                              onChanged: (value) {
                                setState(() {
                                  selectedSign = value as String;
                                });
                              },
                              scrollbarAlwaysShow: true,
                              scrollbarRadius:
                                  const Radius.circular(kDefaultPaddingValue),
                              buttonHeight: selectedSign == null ? 5.h : 8.h,
                              buttonWidth: 100.w,
                              itemHeight: 8.h,
                              buttonElevation: 10,
                              dropdownElevation: 2,
                              dropdownMaxHeight: 50.h,
                              dropdownDecoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight:
                                          Radius.circular(kDefaultPaddingValue),
                                      bottomLeft: Radius.circular(
                                          kDefaultPaddingValue))),

                              searchController: searchSignController,
                              searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  controller: searchSignController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPaddingValue / 2,
                                      vertical: kDefaultPaddingValue,
                                    ),
                                    hintText: 'T??m bi???n b??o...',
                                    hintStyle: const TextStyle(fontSize: 18),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultPaddingValue / 2),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return (item.value
                                    .toString()
                                    .contains(searchValue));
                              },
                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  searchSignController.clear();
                                }
                              },
                            ),
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(height: kDefaultPaddingValue),
                Row(
                  children: [
                    const Text(
                      'H??nh ???nh x??c nh???n:',
                      style: TextStyle(
                        fontSize: FONTSIZES.textPrimary,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: captureImage,
                      child: const Icon(Icons.camera_alt_rounded),
                    ),
                    SizedBox(width: 1.w),
                    ElevatedButton(
                      onPressed: selectImage,
                      child: const Icon(Icons.upload_rounded),
                    ),
                  ],
                ),
                Container(
                  height: pickedFile != null ? 50.h : 30.h,
                  width: 100.w,
                  margin: const EdgeInsets.only(top: kDefaultPaddingValue / 2),
                  child: pickedFile != null
                      ? Container(
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
                        )
                      : Container(
                          height: 10.h,
                          width: 100.w,
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
                  onPressed:
                      pickedFile != null && adminId != null && status != null
                          ? widget.operationType != 2
                              ? (selectedSign != null
                                  ? () => uploadImage(context)
                                  : null)
                              : () => uploadImage(context)
                          : null,
                  child: Padding(
                    padding: EdgeInsets.all((kDefaultPaddingValue / 8).h),
                    child: const Text('G???i X??c nh???n'),
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
