import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/models/Sign.dart';
import 'package:vnrdn_tai/models/dtos/signCategoryDTO.dart';
import 'package:vnrdn_tai/shared/constants.dart';

class SignService {
  List<SignCategoryDTO> parseSignCategoryDTOList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<SignCategoryDTO>((json) => SignCategoryDTO.fromJson(json))
        .toList();
  }

  Sign parseSign(String responseBody) {
    final parsed = json.decode(responseBody);
    return Sign(parsed['id'], parsed['name'], parsed['description'],
        parsed['imageUrl']);
  }

  Future<List<SignCategoryDTO>> GetSignCategoriesDTOList() async {
    try {
      final res = await http
          .get(Uri.parse("${url}SignCategories/GetSignCategoriesDTOList"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        return parseSignCategoryDTOList(res.body);
      } else {
        throw Exception('Không tải được dữ liệu.');
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } on Exception {
      throw Exception('Không thể kết nối');
    }
  }

  Future<Sign?> GetSignByName(String signName) async {
    try {
      final res = await http
          .get(Uri.parse("${url}Signs/GetSignByName?signName=$signName"))
          .timeout(const Duration(seconds: TIME_OUT));
      if (res.statusCode == 200) {
        log(res.body);
        return parseSign(res.body);
      } else {
        return null;
      }
    } on TimeoutException {
      throw Exception('Không tải được dữ liệu.');
    } on Exception {
      throw Exception('Không thể kết nối');
    }
  }
}
