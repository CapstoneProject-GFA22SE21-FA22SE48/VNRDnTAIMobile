import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';

class AnalysisController extends GetxController {
  GlobalController gc = Get.find<GlobalController>();

  late FlutterVision vision;

  late bool _isLoaded = false;
  bool get isLoaded => this._isLoaded;

  late bool _isDetecting = false;
  bool get isDetecting => this._isDetecting;

  late List<Map<String, dynamic>> _modelResults;
  List<Map<String, dynamic>> get modelResults => this._modelResults;

  late CameraImage _cameraImage;
  CameraImage get cameraImage => this._cameraImage;

  late CameraController _cameraController;
  CameraController get cameraController => this._cameraController;

  late List<dynamic>? _recognitionsList;
  List<dynamic>? get recognitionsList => this._recognitionsList;

  @override
  onInit() {
    initCamera();
    super.onInit();
  }

  initCamera() {
    List<CameraDescription> cameras = gc.cameras;
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      vision = FlutterVision();

      loadYoloModel().then((value) {
        _isLoaded = true;
        _isDetecting = false;
        _modelResults = [];
        update();
      });
    });
  }

  Future<void> loadYoloModel() async {
    final responseHandler = await vision.loadYoloModel(
        labels: 'assets/best-fp16.txt',
        modelPath: 'assets/best-fp16.tflite',
        numThreads: 1,
        useGpu: false);
    if (responseHandler.type == 'success') {
      _isLoaded = true;
      update();
    }
  }

  Future<void> startImageStream() async {
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    Timer(Duration(seconds: 3), () {
      _isDetecting = true;
    });
    await _cameraController.startImageStream((image) async {
      print(_isDetecting);
      if (!_isDetecting) {
        return;
      }

      try {
        await yoloOnFrame(image);
        await _cameraController.stopImageStream();
      } catch (e) {
        throw Exception(e);
      } finally {
        _isDetecting = false;
      }
    });

    update();
  }

  Future<void> stopImageStream() async {
    if (!_cameraController.value.isInitialized) {
      print('controller not initialized');
      return;
    }
    if (_cameraController.value.isStreamingImages) {
      await _cameraController.stopImageStream();
    }
    _isDetecting = false;
    _modelResults.clear();
    update();
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    print('owo');
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.6,
        confThreshold: 0.01);

    _modelResults = result.data as List<Map<String, dynamic>>;
    print("Biển ${modelResults[0]['tag']}");
  }

  runModel() async {
    // updateCameraImage(cameraImage);
  }

  updateCameraImage(val) {
    _cameraImage = val;
  }

  @override
  void dispose() async {
    await vision.closeYoloModel();
    _cameraController.stopImageStream();
    super.dispose();
  }
}
