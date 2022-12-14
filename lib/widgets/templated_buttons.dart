import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class TemplatedButtons {
  final ButtonStyle confirmStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: kPrimaryButtonColor,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  final ButtonStyle cancelStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: kDangerButtonColor,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      backgroundColor: Colors.grey.shade300,
      shadowColor: Colors.grey,
      minimumSize: const Size(80, 40));

  static TextButton ok(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'ĐỒNG Ý');
      },
      child: const Text(
        "ĐỒNG Ý",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton okWithscreen(BuildContext context, Widget screen) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'ĐỒNG Ý');
        Get.offAll(screen);
      },
      child: const Text(
        "ĐỒNG Ý",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton okWithMethod(BuildContext context, Future function) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () => function,
      child: const Text(
        "ĐỒNG Ý",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton cancel(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().cancelStyle,
      onPressed: () {
        Navigator.pop(context, 'HUỶ BỎ');
      },
      child: const Text(
        "HUỶ BỎ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton deny(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().cancelStyle,
      onPressed: () {
        Navigator.pop(context, 'TỪ CHỐI');
      },
      child: const Text(
        "TỪ CHỐI",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton yes(BuildContext context, Widget screen) {
    return TextButton(
      style: TemplatedButtons().confirmStyle,
      onPressed: () {
        Navigator.pop(context, 'CÓ');
        Get.offAll(screen);
      },
      child: const Text(
        "CÓ",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton no(BuildContext context) {
    return TextButton(
      style: TemplatedButtons().disabledStyle,
      onPressed: () {
        Navigator.pop(context, 'KHÔNG');
      },
      child: const Text(
        "KHÔNG",
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }
}
