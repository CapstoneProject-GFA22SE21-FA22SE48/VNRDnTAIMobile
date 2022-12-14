import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/models/dtos/AdminDTO.dart';
import 'package:vnrdn_tai/models/dtos/ProfileDTO.dart';
import 'package:vnrdn_tai/services/AuthService.dart';
import 'package:vnrdn_tai/utils/io_utils.dart';

import '../shared/constants.dart';

class UserService {
  AuthController ac = Get.put(AuthController());
  List<AdminDTO> parseAdmins(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<AdminDTO>((json) => AdminDTO(
            json['id'],
            json['username'],
            json['pendingRequests'],
            json['email'],
            json['avatar'],
            json['displayName'],
            json['role']))
        .toList();
  }

  Future<List<AdminDTO>> getAdmins() async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http.get(Uri.parse("${url}Users/Admins"), headers: {
          'Authorization': 'Bearer ${ac.token.value}',
        }).timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return parseAdmins(res.body);
        } else if (res.statusCode == 500) {
          return [];
        }
      }
      return [];
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> updateProfile(
      String avatar, String email, String displayName) async {
    try {
      GlobalController gc = Get.find<GlobalController>();

      if (gc.userId.value.isNotEmpty) {
        final res = await http
            .put(
              Uri.parse("${url}Users/${gc.userId.value}/UpdateProfile"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${ac.token.value}',
              },
              body: jsonEncode(ProfileDTO(email, avatar, displayName)),
            )
            .timeout(const Duration(seconds: TIME_OUT));

        print(res.body);
        if (res.statusCode == 200) {
          String token = AuthService().parseToken(res.body);
          IOUtils.setUserInfoController(token);
          IOUtils.saveToStorage('token', token);
          return "Thông tin đã được thay đổi";
        } else if (res.statusCode == 500 || res.statusCode == 409) {
          return res.body;
        }
      }
      return '';
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }

  Future<String> deactivate() async {
    try {
      GlobalController gc = Get.put(GlobalController());

      if (gc.userId.value != '') {
        final res = await http.put(
            Uri.parse("${url}Users/SelfDeactivate/${gc.userId.value}"),
            headers: {
              'Authorization': 'Bearer ${ac.token.value}',
            }).timeout(const Duration(seconds: TIME_OUT));
        if (res.statusCode == 200) {
          return "Ngưng hoạt động thành công.";
        } else if (res.statusCode == 400) {
          return res.body;
        }
      }
      return '';
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    }
  }
}
