import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter_ocr/logger.dart';

import 'ocr_result.dart';

typedef CreatePipeline = Pointer<Void> Function(
    Pointer<Utf8>, // det_model_path
    Pointer<Utf8>, // rec_model_path
    Pointer<Utf8>, // cls_model_path
    Pointer<Utf8>, // cPUPowerMode
    Pointer<Int32>, // cPUThreadNum
    Pointer<Utf8>, // det_config_path
    Pointer<Utf8> // dict_path
    );

typedef ProcessOCR = OcrResult Function(Pointer<Void>, Pointer<Utf8>);

//  <det_model_path> <rec_model_path> <cls_model_path>
// <runtime_device> <precision> <num_threads> <batch_size> <img_dir>
// <det_config_path> <dict_path> "
class OcrPipeline {
  late final DynamicLibrary _pipelineLib;
  late final CreatePipeline _createPipeline;
  late final ProcessOCR _process;
  Pointer<Void>? _pipeline;

  OcrPipeline({
    required String detModelDir,
    required String clsModelDir,
    required String recModelDir,
    String cPUPowerMode = 'LITE_POWER_HIGH',
    int cPUThreadNum = 1,
    required String dictPath,
    required String configPath,
  }) {
    try {
      _pipelineLib = Platform.isAndroid
          ? DynamicLibrary.open('libpipeline.so')
          : DynamicLibrary.process();

      _createPipeline = _pipelineLib
          .lookup<NativeFunction<CreatePipeline>>('initPipeline')
          .asFunction();

      _process = _pipelineLib
          .lookup<NativeFunction<ProcessOCR>>('processImage')
          .asFunction();

      // Khởi tạo pipeline
      final detModelDirPtr = detModelDir.toNativeUtf8();
      final clsModelDirPtr = clsModelDir.toNativeUtf8();
      final recModelDirPtr = recModelDir.toNativeUtf8();
      final cPUPowerModePtr = cPUPowerMode.toNativeUtf8();
      final cPUThreadNumPtr = calloc<Int32>()..value = cPUThreadNum;
      final dictPathPtr = dictPath.toNativeUtf8();
      final configPathPtr = configPath.toNativeUtf8();

      _pipeline = _createPipeline(
        detModelDirPtr, // det_model_path
        recModelDirPtr, // rec_model_path
        clsModelDirPtr, // cls_model_path
        cPUPowerModePtr, // cPUPowerMode
        cPUThreadNumPtr, // cPUThreadNum
        configPathPtr, // det_config_path
        dictPathPtr, // dict_path
      );

      calloc.free(detModelDirPtr);
      calloc.free(clsModelDirPtr);
      calloc.free(recModelDirPtr);
      calloc.free(configPathPtr);
      calloc.free(dictPathPtr);
      calloc.free(cPUPowerModePtr);
      calloc.free(cPUThreadNumPtr);
    } catch (e) {
      Logger.log(e);
    }
  }

  OcrResult process(String imagePath) {
    final imagePathPtr = imagePath.toNativeUtf8();
    final result = _process(_pipeline!, imagePathPtr);
    calloc.free(imagePathPtr);
    return result;
  }

  void dispose() {
    if (_pipeline != null) {
      _pipeline = null;
    }
  }
}
