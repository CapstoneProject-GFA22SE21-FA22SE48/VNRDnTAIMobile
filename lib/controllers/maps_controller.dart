import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';

class MapsController extends GetxController {
  static MapsController instance = Get.find();
  Location location = Location();
  late List<GPSSign> _listSigns;
  final zoom = 21.0.obs;

  List<GPSSign> get listSigns => _listSigns;

  @override
  Future<void> onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  @override
  dispose() {
    updateZoom(18.0);
    super.dispose();
  }

  updateZoom(value) {
    zoom(value);
  }
}
