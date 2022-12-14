import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vnrdn_tai/shared/constants.dart';

Future<File> compressFile(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  var result = (await FlutterImageCompress.compressAndGetFile(
    minHeight: 640,
    minWidth: 640,
    file.absolute.path,
    outPath,
    quality: 60,
  ))!;

  print(file.lengthSync());
  print(result.lengthSync());

  return result;
}

upload(File imageFile, {bool cont = true, String url = ai_url}) async {
  if (!cont) return "[]";
  // open a bytestream
  var _imageFile = await compressFile(imageFile);
  // var _imageFile = imageFile;

  var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
  // get file length
  var length = await _imageFile.length();
  // string to uri
  var uri = Uri.parse(url);

  // create multipart request
  var request = http.MultipartRequest("POST", uri);
  // multipart that takes file
  var multipartFile = http.MultipartFile('file', stream, length,
      filename: basename(_imageFile.path));

  request.files.add(multipartFile);

  Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept": "*/*",
    "Connection": "keep-alive"
  };
  // add file to multipart
  request.headers.addAll(headers);
  // send
  print('sent');
  try {
    var response = await request.send();
    return await response.stream.bytesToString();
  } on Exception catch (ex) {
    print(ex);
  }
}

numberEngToVietWord(String input) {
  var res = input;
  res = res
      .replaceAll("eleven", "m?????i m???t")
      .replaceAll("twelve", "m?????i hai")
      .replaceAll("thirteen", "m?????i ba")
      .replaceAll("fourteen", "m?????i b???n")
      .replaceAll("fifteen", "m?????i l??m")
      .replaceAll("sixteen", "m?????i s??u")
      .replaceAll("seventeen", "m?????i b???y")
      .replaceAll("eighteen", "m?????i t??m")
      .replaceAll("nineteen", "m?????i ch??n")
      .replaceAll("twenty", "hai m????i")
      .replaceAll("thirty", "ba m????i")
      .replaceAll("fourty", "b???n m????i")
      .replaceAll("fifty", "n??m m????i")
      .replaceAll("sixty", "s??u m????i")
      .replaceAll("seventy", "b???y m????i")
      .replaceAll("eighty", "t??m m????i")
      .replaceAll("ninety", "ch??n m????i")
      .replaceAll("zero", "kh??ng")
      .replaceAll("one", "m???t")
      .replaceAll("two", "hai")
      .replaceAll("three", "ba")
      .replaceAll("four", "b???n")
      .replaceAll("five", "n??m")
      .replaceAll("six", "s??u")
      .replaceAll("seven", "b???y")
      .replaceAll("eight", "t??m")
      .replaceAll("nine", "ch??n")
      .replaceAll("ten", "m?????i")
      .replaceAll("hundred", "tr??m")
      .replaceAll("thousand", "ngh??n")
      .replaceAll("million", "tri???u")
      .replaceAll("billion", "t???");
  return res;
}

defaultDivider() {
  return const Divider(
    height: 10,
    thickness: 1,
    color: Colors.black,
  );
}

handleError(value) {
  Get.snackbar('L???i', '$value', colorText: Colors.red, isDismissible: true);
  Get.offAll(() => ContainerScreen());
}

loadingScreen() {
  return const Center(
    child: GFLoader(
      size: GFSize.LARGE,
      loaderstrokeWidth: 5.4,
    ),
  );
}
