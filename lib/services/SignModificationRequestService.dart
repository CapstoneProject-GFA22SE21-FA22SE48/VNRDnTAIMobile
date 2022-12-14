import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import 'package:vnrdn_tai/models/dtos/CreateSignRequest.dart';
import 'package:vnrdn_tai/models/dtos/GPSSignManipulateDTO.dart';
import 'package:vnrdn_tai/models/dtos/ManipulateSignRequest.dart';
import '../shared/constants.dart';

class SignModificationRequestService {
  AuthController ac = Get.put(AuthController());
  static List<SignModificationRequest> parseSignModificationRequestList(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SignModificationRequest>(
            (json) => SignModificationRequest.fromJson(json))
        .toList();
  }

  static SignModificationRequest parseSignModificationRequest(
      String responseBody) {
    final parsed = Map<String, dynamic>.from(json.decode(responseBody));
    return SignModificationRequest.fromJson(parsed);
  }

  // get all SignModificationRequests of Claimed (2) status
  Future<List<SignModificationRequest>> getClaimedRequests() async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http.get(
          Uri.parse(
            "${url}SignModificationRequests/Scribes/${gc.userId.value}/2",
          ),
          headers: {
            'Authorization': 'Bearer ${ac.token.value}',
          }).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseSignModificationRequestList(res.body);
      } else {
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // put an update of Confirmation with image as evidence
  Future<SignModificationRequest?> confirmEvidence(String gpsSignRomId,
      int status, String imageUrl, String adminId, String? signId) async {
    try {
      if (signId != null) {
        imageUrl = '$imageUrl%2F%$signId';
      }
      final res = await http
          .put(
            Uri.parse(
                "${url}SignModificationRequests/GPSSigns/$gpsSignRomId/$status/$adminId"),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8",
              'Authorization': 'Bearer ${ac.token.value}',
            },
            body: jsonEncode(imageUrl),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseSignModificationRequest(res.body);
      } else {
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // scribe request with type create of GPSSigns
  Future<SignModificationRequest?> createScribeRequestGpsSign(
      String imageUrl, String adminId, GPSSign? newGpsSign) async {
    GlobalController gc = Get.put(GlobalController());
    CreateSignRequest request;
    try {
      request = CreateSignRequest(
          newGpsSign!.signId,
          null,
          null,
          newGpsSign.id,
          null,
          null,
          gc.userId.value,
          adminId,
          0,
          imageUrl,
          3,
          null,
          DateTime.now().toLocal().toString(),
          false,
          newGpsSign);
      final res = await http
          .post(Uri.parse("${url}SignModificationRequests/AddGps"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
                'Authorization': 'Bearer ${ac.token.value}',
              },
              body: jsonEncode(request))
          .timeout(const Duration(seconds: TIME_OUT));
      print(res.statusCode);
      if (res.statusCode == 201) {
        print(res.body);
        return SignModificationRequestService.parseSignModificationRequest(
            res.body);
      } else {
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // scribe request with type update/delete of GPSSigns
  Future<SignModificationRequest?> scribeRequestManipulateGpsSign(
      String imageUrl,
      String? modifiedGpssignId,
      String adminId,
      GPSSignManipulateDTO? newGpsSign,
      int operationType) async {
    GlobalController gc = Get.put(GlobalController());
    ManipulateSignRequest request;
    try {
      request = ManipulateSignRequest(
          newGpsSign!.signId,
          null,
          null,
          newGpsSign.signId,
          modifiedGpssignId,
          gc.userId.value,
          gc.userId.value,
          adminId,
          operationType,
          imageUrl,
          3,
          null,
          DateTime.now().toLocal().toString(),
          false,
          newGpsSign);
      final res = await http
          .post(Uri.parse("${url}SignModificationRequests/AddGps"),
              headers: <String, String>{
                "Content-Type": "application/json; charset=UTF-8",
                'Authorization': 'Bearer ${ac.token.value}',
              },
              body: jsonEncode(request))
          .timeout(const Duration(seconds: TIME_OUT));
      print(res.statusCode);
      if (res.statusCode == 201) {
        print(res.body);
        return SignModificationRequestService.parseSignModificationRequest(
            res.body);
      } else {
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
