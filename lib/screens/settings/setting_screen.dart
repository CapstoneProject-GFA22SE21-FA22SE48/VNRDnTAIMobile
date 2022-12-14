import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/settings/change_password_screen.dart';
import 'package:vnrdn_tai/screens/settings/profile_screen.dart';
import 'package:vnrdn_tai/services/UserService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchClassState();
}

class _SwitchClassState extends State<SettingsScreen> {
  GlobalController gc = Get.put(GlobalController());

  launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  confirmDeactivate() {
    DialogUtil.showAwesomeDialog(context, DialogType.warning, "Cảnh báo",
        "Bạn cần phải liên hệ đội ngũ phát triển để có thể kích hoạt lại tài khoản.",
        () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(children: const [Text('Đang xử lý')])),
      );
      selfDeactivate();
    }, () {});
  }

  selfDeactivate() {
    UserService().deactivate().then((value) {
      if (value.contains('thành công')) {
        IOUtils.removeAllData();
        IOUtils.clearUserInfoController();

        DialogUtil.showAwesomeDialog(
            context,
            DialogType.success,
            "Thành công",
            'Tài khoản đã ngưng hoạt động!\nVui lòng liên hệ đội ngũ phát triển nếu muốn kích hoạt lại.',
            () => Get.to(() => const ContainerScreen()),
            null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cài đặt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => const ContainerScreen()),
        ),
      ),
      body: SizedBox(
        height: 90.h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: kDefaultPaddingValue / 2,
                    horizontal: kDefaultPaddingValue),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(197, 189, 189, 189),
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    )
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    gc.pushNotiMode.value
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_off_rounded,
                    color: gc.pushNotiMode.value
                        ? kPrimaryButtonColor
                        : kDisabledButtonColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  title: Row(children: [
                    Text(
                      'Thông báo',
                      style: TextStyle(
                        color: gc.pushNotiMode.value
                            ? kPrimaryButtonColor
                            : kDisabledButtonColor,
                        fontSize: FONTSIZES.textMediumLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      dragStartBehavior: DragStartBehavior.start,
                      value: gc.pushNotiMode.value,
                      activeColor: Colors.blueAccent,
                      trackColor: Colors.grey,
                      onChanged: (value) {
                        setState(() {
                          gc.updatePushNotiMode(value);
                        });
                      },
                    ),
                  ]),
                ),
              ),
              // profile
              gc.userId.value.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        Get.to(const LoaderOverlay(child: ProfileScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddingValue / 2,
                            horizontal: kDefaultPaddingValue),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(197, 189, 189, 189),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          leading: const Icon(
                            Icons.account_box_rounded,
                            color: kSuccessButtonColor,
                          ),
                          title: Row(
                            children: const [
                              Text(
                                'Cập nhật thông tin',
                                style: TextStyle(
                                  color: kSuccessButtonColor,
                                  fontSize: FONTSIZES.textMediumLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // change password
              gc.userId.value.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        Get.to(
                          () => LoaderOverlay(
                            child: ChangePasswordScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddingValue / 2,
                            horizontal: kDefaultPaddingValue),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(197, 189, 189, 189),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.password_rounded,
                            color: kWarningButtonColor,
                          ),
                          title: Row(
                            children: const [
                              Text(
                                'Đổi mật khẩu',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: kWarningButtonColor,
                                  fontSize: FONTSIZES.textMediumLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // helps
              GestureDetector(
                onTap: () {
                  launchURL('https://fb.com/profile.php?id=100086524863274'
                      // 'https://fb.com/messages/t/102757259281351'
                      );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: kDefaultPaddingValue / 2,
                      horizontal: kDefaultPaddingValue),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(197, 189, 189, 189),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    leading: const Icon(Icons.help_outline),
                    title: Row(
                      children: const [
                        Text(
                          'Liên hệ với chúng tôi',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: FONTSIZES.textMediumLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // deactivate
              gc.userId.value.isNotEmpty
                  ? GestureDetector(
                      onTap: selfDeactivate,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPaddingValue / 2,
                            horizontal: kDefaultPaddingValue),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(197, 189, 189, 189),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          tileColor: Colors.white,
                          leading: const FaIcon(
                            FontAwesomeIcons.hand,
                            color: kDangerButtonColor,
                          ),
                          title: Row(
                            children: const [
                              Text(
                                'Ngưng hoạt động',
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: kDangerButtonColor,
                                  fontSize: FONTSIZES.textMediumLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
