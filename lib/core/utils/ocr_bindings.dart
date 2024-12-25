import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Definition function Prototypes
///
/// This section defines the function prototypes used in the OCR pipeline.
///
/// `InitPipelineFunc` represents the function signature for initializing the pipeline.
/// It takes seven parameters:
/// - `detModelDir`: The directory path for the detection model.
/// - `clsModelDir`: The directory path for the classification model.
/// - `recModelDir`: The directory path for the recognition model.
/// - `cPUPowerMode`: The CPU power mode to use.
/// - `cPUThreadNum`: The number of CPU threads to use.
/// - `configPath`: The path to the configuration file.
/// - `dictPath`: The path to the dictionary file.
///
/// `InitPipeline` is a Dart function type that matches `InitPipelineFunc`.
///
/// `ProcessImageFunc` represents the function signature for processing an image.
/// It takes a single parameter:
/// - `imagePath`: The path to the image file to process.
///
/// `ProcessImage` is a Dart function type that matches `ProcessImageFunc`.

typedef InitPipelineFunc = Bool Function(
  Pointer<Utf8> detModelDir,
  Pointer<Utf8> recModelDir,
  Pointer<Utf8> cPUPowerMode,
  Int32 cPUThreadNum,
  Pointer<Utf8> configPath,
);
typedef InitPipeline = bool Function(
  Pointer<Utf8> detModelDir,
  Pointer<Utf8> recModelDir,
  Pointer<Utf8> cPUPowerMode,
  int cPUThreadNum,
  Pointer<Utf8> configPath,
);

typedef ProcessImageFunc = Pointer<Utf8> Function(Pointer<Utf8> imagePath);

typedef ProcessImage = Pointer<Utf8> Function(Pointer<Utf8> imagePath);

class OcrBindings {
  factory OcrBindings() => _instance;
  static final OcrBindings _instance = OcrBindings();
  static final DynamicLibrary _ocrLib = Platform.isAndroid
      ? DynamicLibrary.open('libpipeline.so')
      : DynamicLibrary.process();

  static final InitPipeline _initPipeline = _ocrLib
      .lookupFunction<InitPipelineFunc, InitPipeline>('initGlobalPipeline');

  static final ProcessImage _processImage = _ocrLib
      .lookupFunction<ProcessImageFunc, ProcessImage>('processImageGlobal');

  static bool initPipeline({
    required String detModelDir,
    required String recModelDir,
    required String cPUPowerMode,
    required int cPUThreadNum,
    required String configPath,
  }) {
    final detModelDirPtr = detModelDir.toNativeUtf8();
    final recModelDirPtr = recModelDir.toNativeUtf8();
    final cPUPowerModePtr = cPUPowerMode.toNativeUtf8();
    final configPathPtr = configPath.toNativeUtf8();

    final result = _initPipeline(
      detModelDirPtr,
      recModelDirPtr,
      cPUPowerModePtr,
      cPUThreadNum,
      configPathPtr,
    );

    malloc
      ..free(detModelDirPtr)
      ..free(recModelDirPtr)
      ..free(cPUPowerModePtr)
      ..free(configPathPtr);

    return result;
  }

  static String processImage(String imagePath) {
    final imagePathPtr = imagePath.toNativeUtf8();
    final resultPtr = _processImage(imagePathPtr);
    final result = resultPtr.toDartString();
    malloc
      ..free(imagePathPtr)
      ..free(resultPtr);
    return result;
  }
}
