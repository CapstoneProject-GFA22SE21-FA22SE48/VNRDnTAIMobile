// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kPrimaryButtonColor = Color.fromARGB(255, 51, 102, 255);
const kDangerButtonColor = Color.fromARGB(255, 239, 68, 68);
const kSuccessButtonColor = Color.fromARGB(255, 34, 197, 94);
const kWarningButtonColor = Color.fromARGB(255, 245, 159, 11);
const kNeutralButtonColor = Color.fromARGB(255, 160, 44, 255);
const kDisabledButtonColor = Color.fromARGB(255, 108, 117, 125);
const kPrimaryTextColor = Color.fromARGB(255, 51, 51, 51);
const kDisabledTextColor = Color.fromARGB(255, 102, 102, 102);

const kPrimaryGradientColor = Color.fromARGB(255, 51, 102, 255);
const kDangerGradientColor = Color.fromARGB(255, 239, 68, 68);
const kSuccessGradientColor = Color.fromARGB(255, 34, 197, 94);
const kWarningGradientColor = Color.fromARGB(255, 245, 159, 11);
const kDisabledGradientColor = Color.fromARGB(255, 108, 117, 125);

const kBlueAccentBackground = Colors.blueAccent;
const kLightBlueBackground = Color(0xFFA9CAFF);

const kPrimaryBackgroundColor = Color.fromARGB(255, 255, 255, 255);

const double kDefaultPaddingValue = 16;
const kDefaultPadding = EdgeInsets.all(kDefaultPaddingValue);

const quizTime = 60 * 19; // 25 cau
const quizTimeB1 = 60 * 20; // 35 cau
const numberOfQuestion = 25;
const numberOfQuestionB1 = 30;
const minOfQuestion = 21;
const minOfQuestionA2 = 23;
const minOfQuestionB1 = 28;

final ButtonStyle kDefaultButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: FONTSIZES.textPrimary),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey,
    alignment: Alignment.center,
    minimumSize: const Size(200, 100),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));

final ButtonStyle kModeChoosingButtonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: FONTSIZES.textLarge),
  backgroundColor: Colors.blueAccent.shade200,
  shadowColor: Colors.grey,
  alignment: Alignment.center,
  minimumSize: const Size(200, 10),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kDefaultPaddingValue)),
);

class PROGRESS_COLOR {
  static const Color none = Colors.grey;
  static const Color little = Colors.redAccent;
  static const Color nearly50 = Colors.orangeAccent;
  static const Color greater50 = Colors.yellowAccent;
  static const Color almost = Color(0xFFA6F069);
  static const Color done = Colors.greenAccent;
}

enum TEST_TYPE { STUDY, TEST }

enum TABS { SEARCH, MOCK_TEST, ANALYSIS, MINIMAP, WELCOME, LOGIN, SIGNUP }

class FONTSIZES {
  static const double textTiny = 8;
  static const double textMini = 10;
  static const double textSmall = 12;
  static const double textMedium = 14;
  static const double textPrimary = 16;
  static const double textMediumLarge = 18;
  static const double textLarge = 20;
  static const double textLarger = 24;
  static const double textHuge = 28;
  static const double textVeryHuge = 32;
}

const TIME_OUT = 60;
const TIME_OUT_SCAN = 60;

const emptyUserId = "00000000-0000-0000-0000-000000000000"; // jwt fixed
const defaultAvatarUrl =
    "https://firebasestorage.googleapis.com/v0/b/vnrdntai.appspot.com/o/images%2Favatar%2Fdefault_avatar_x05.png?alt=media";

const String google_api_key = "AIzaSyBEre7YKax4irpLfr0I2jrkACu_ZiBL3JU";
const String maps_key = "AIzaSyBbz-SI9Kfr203lCvmMBEV3zEu0u9B08T0";
// const String maps_key = "AIzaSyDM1rM5UcyCqdSD_R-4qEm8wd-K9mLCrFA"; // Phuc
LatLng schoolLocation = // FPT daigaku
    const LatLng(10.841809162754405, 106.8097469445683);

// const url = "https://10.0.2.2:5001/api/";
const url = "https://vnrdntaiapi.azurewebsites.net/api/";

// const ai_url = "http://10.0.2.2:5000/";
const ai_url = "https://vnrdntai-ai.azurewebsites.net/";
// const ai_url = "https://cac3-14-169-2-3.ap.ngrok.io";
