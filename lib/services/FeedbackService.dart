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
import 'SignModificationRequestService.dart';

class FeedbackService {
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
        return SignModificationRequestService.parseSignModificationRequestList(
            res.body);
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
      GPSSign? oldGpsSign,
      GPSSign? newGpsSign) async {
    GlobalController gc = Get.put(GlobalController());
    SignModificationRequest request;
    try {
      switch (requestType) {
        case 'noSignHere':
          request = SignModificationRequest(
              null,
              null,
              null,
              newGpsSign!.id,
              oldGpsSign!.id,
              gc.userId.value,
              null,
              null,
              2,
              imageUrl,
              0,
              DateTime.now());
          break;
        case 'wrongSign':
          request = SignModificationRequest(
              null,
              null,
              null,
              newGpsSign!.id,
              oldGpsSign!.id,
              gc.userId.value,
              null,
              null,
              1,
              imageUrl,
              0,
              DateTime.now());
          break;
        default:
          request = SignModificationRequest(
              null,
              null,
              null,
              newGpsSign!.id,
              null,
              gc.userId.value,
              null,
              null,
              0,
              imageUrl,
              0,
              DateTime.now());
      }
      final res = await http.post(
        Uri.parse("${url}SignModificationRequests"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: {request},
      ).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return SignModificationRequestService.parseSignModificationRequest(
            res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<SignModificationRequest?> createSignsModificationRequest(
      SignModificationRequest rom) async {
    try {
      final res = await http.post(Uri.parse("${url}SignModificationRequests"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: {
            jsonEncode(rom)
          }).timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 201) {
        return SignModificationRequestService.parseSignModificationRequest(
            res.body);
      } else {
        log(res.body);
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
