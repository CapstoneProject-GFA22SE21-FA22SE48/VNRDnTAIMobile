import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/SignModificationRequest.dart';
import '../shared/constants.dart';

class FeedbackService {
  List<SignModificationRequest> parseSignModificationRequestList(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SignModificationRequest>(
            (json) => SignModificationRequest.fromJson(json))
        .toList();
  }

  SignModificationRequest parseSignModificationRequest(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return SignModificationRequest.fromJson(parsed);
  }

  // get all Feedback of Signs
  Future<List<SignModificationRequest>> getFeedbacks(
    String requestType,
  ) async {
    GlobalController gc = Get.put(GlobalController());
    try {
      final res = await http
          .get(
            Uri.parse(
              "${url}Users/SignModificationRequests/${gc.userId.value}?Type=$requestType",
            ),
          )
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        return parseSignModificationRequestList(res.body);
      } else {
        log(res.body);
        return [];
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  // create Feedback of GPSSigns
  Future<SignModificationRequest?> createGpsSignsModificationRequest(
      String requestType,
      String imageUrl,
      GPSSign? oldSign,
      GPSSign? newSign) async {
    GlobalController gc = Get.put(GlobalController());
    SignModificationRequest request;
    try {
      switch (requestType) {
        case 'noSignHere':
          request = SignModificationRequest(null, newSign!.id, null,
              gc.userId.value, 2, imageUrl, 0, DateTime.now());
          break;
        case 'wrongSign':
          request = SignModificationRequest(null, newSign!.id, null,
              gc.userId.value, 1, imageUrl, 0, DateTime.now());
          break;
        default:
          request = SignModificationRequest(null, newSign!.id, null,
              gc.userId.value, 0, imageUrl, 0, DateTime.now());
      }
      final res = await http.post(
        Uri.parse("${url}SignModificationRequests"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: {request},
      ).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return parseSignModificationRequest(res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
