import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Image.asset(
            //       "assets/images/logo.png",
            //       height: 32.0,
            //     ),
            //     const Padding(
            //       padding: EdgeInsets.only(left: 5.0),
            //       child: Text(
            //         "VNRDnTAI",
            //         style: TextStyle(
            //             fontWeight: FontWeight.w600,
            //             fontSize: FONTSIZES.textMediumLarge,
            //             color: kPrimaryTextColor),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: kDefaultPaddingValue * 2),
            Image.asset(
              "assets/images/logo.png",
              height: isKeyboardVisible ? 120 : 180,
            ),
            const SizedBox(height: kDefaultPaddingValue),
            const Text(
              "ĐĂNG KÝ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FONTSIZES.textHuge,
                  color: kPrimaryButtonColor),
            ),
            const SizedBox(height: kDefaultPaddingValue * 2),
          ],
        );
      },
    );
  }
}
