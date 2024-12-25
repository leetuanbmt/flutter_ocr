import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../logger.dart';
import '../constants/assets.gen.dart';
import '../models/ocr_result.dart';

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
  Pointer<Utf8> clsModelDir,
  Pointer<Utf8> recModelDir,
  Pointer<Utf8> cPUPowerMode,
  Int32 cPUThreadNum,
  Pointer<Utf8> configPath,
  Pointer<Utf8> dictPath,
);
typedef InitPipeline = bool Function(
  Pointer<Utf8> detModelDir,
  Pointer<Utf8> clsModelDir,
  Pointer<Utf8> recModelDir,
  Pointer<Utf8> cPUPowerMode,
  int cPUThreadNum,
  Pointer<Utf8> configPath,
  Pointer<Utf8> dictPath,
);

typedef ProcessImageFunc = Pointer<Utf8> Function(Pointer<Utf8> imagePath);

typedef ProcessImage = Pointer<Utf8> Function(Pointer<Utf8> imagePath);

/// Load the sharing library
///
/// This section loads the native library for the OCR pipeline.
/// The library is dynamically loaded based on the platform (Android or iOS).
final DynamicLibrary _nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('libpipeline.so')
    : DynamicLibrary.process();

/// A request to process an OCR image.
///
/// This class represents a request to process an OCR image.
/// It contains two properties:
/// - `id`: A unique identifier for the request.
/// - `imagePath`: The path to the image file to process.
class _OcrRequest {
  const _OcrRequest(this.id, this.imagePath);
  final int id;
  final String imagePath;
}

/// A response with the result of the OCR processing.
///
/// This class represents a response to an OCR image processing request.
/// It contains two properties:
/// - `id`: The unique identifier of the request this response corresponds to.
/// - `result`: The result of the OCR processing, which can be null if the processing failed.
class _OcrResponse {
  const _OcrResponse(this.id, this.result);
  final int id;
  final String? result;
}

/// Counter to identify [_OcrRequest]s and [_OcrResponse]s.
///
/// This variable keeps track of the next unique identifier to assign to an OCR request or response.
int _nextOcrRequestId = 0;

/// Mapping from [_OcrRequest] `id`s to the completers corresponding to the correct future of the pending request.
///
/// This map stores the completers for OCR requests that are currently being processed.
/// The key is the unique identifier of the request, and the value is the completer for the future of the request.
final Map<int, Completer<String?>> _ocrRequests = <int, Completer<String?>>{};

/// The SendPort belonging to the helper isolate.
///
/// This future returns the SendPort of the helper isolate, which is used for communication between isolates.
Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();

  final ReceivePort receivePort = ReceivePort()
    ..listen((data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _OcrResponse) {
        final Completer<String?> completer = _ocrRequests[data.id]!;
        _ocrRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  /// start the helper isolate
  await Isolate.spawn(
    (SendPort sendPort) async {
      final ReceivePort helperReceivePort = ReceivePort()
        ..listen((data) {
          if (data is _OcrRequest) {
            final result = OcrPipeline._instance.processImage(data.imagePath);
            sendPort.send(_OcrResponse(data.id, result));
            return;
          }
          throw UnsupportedError(
            'Unsupported message type: ${data.runtimeType}',
          );
        });

      sendPort.send(helperReceivePort.sendPort);
    },
    receivePort.sendPort,
  );

  return completer.future;
}();

class OcrPipeline {
  OcrPipeline._internal();
  factory OcrPipeline() => _instance;
  static final OcrPipeline _instance = OcrPipeline._internal();

  bool isInitialized = false;

  void _initOcrPipeline({
    required String detModelDir,
    required String clsModelDir,
    required String recModelDir,
    String cPUPowerMode = 'CPU',
    int cPUThreadNum = 1,
    required String dictPath,
    required String configPath,
  }) {
    try {
      if (isInitialized) return;

      /// Lookup hàm initPipeline
      final InitPipeline initPipeline = _nativeLib
          .lookup<NativeFunction<InitPipelineFunc>>('initGlobalPipeline')
          .asFunction();

      // / Assign value to Global pipeline
      final Pointer<Utf8> detModelDirPtr = detModelDir.toNativeUtf8();
      final Pointer<Utf8> clsModelDirPtr = clsModelDir.toNativeUtf8();
      final Pointer<Utf8> recModelDirPtr = recModelDir.toNativeUtf8();
      final Pointer<Utf8> cPUPowerModePtr = cPUPowerMode.toNativeUtf8();
      final Pointer<Utf8> configPathPtr = configPath.toNativeUtf8();
      final Pointer<Utf8> dictPathPtr = dictPath.toNativeUtf8();

      isInitialized = initPipeline(
        detModelDirPtr,
        clsModelDirPtr,
        recModelDirPtr,
        cPUPowerModePtr,
        cPUThreadNum,
        configPathPtr,
        dictPathPtr,
      );

      /// Release memory after use
      calloc
        ..free(detModelDirPtr)
        ..free(clsModelDirPtr)
        ..free(recModelDirPtr)
        ..free(cPUPowerModePtr)
        ..free(configPathPtr)
        ..free(dictPathPtr);

      Logger.log('Pipeline initialized: $isInitialized');

      if (!isInitialized) {
        throw 'Error: Pipeline initialization failed.';
      }
    } catch (e) {
      throw StateError('Failed to initialize pipeline: $e');
    }
  }

  Future<OCRResult?> processOcrImage(String imagePath) async {
    if (!isInitialized) {
      throw 'Error: Pipeline not initialized.';
    }

    try {
      final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
      final int requestId = _nextOcrRequestId++;
      final _OcrRequest request = _OcrRequest(requestId, imagePath);
      final Completer<String?> completer = Completer<String?>();
      _ocrRequests[requestId] = completer;
      helperIsolateSendPort.send(request);
      final result = await completer.future;
      if (result == null) {
        throw 'Error: Failed to process OCR image.';
      }
      final decoded = jsonDecode(result).cast<String, dynamic>();
      return OCRResult.fromJson(decoded);
    } catch (e) {
      throw 'Error: Failed to process OCR image. $e';
    }
  }

  String? processImage(String imagePath) {
    final ProcessImage processImage = _nativeLib
        .lookup<NativeFunction<ProcessImageFunc>>('processImageGlobal')
        .asFunction<ProcessImage>();

    final Pointer<Utf8> image = imagePath.toNativeUtf8();

    final result = processImage(image);

    calloc.free(image);

    if (result == nullptr) {
      throw 'Error: processImage returned null.';
    }

    return result.toDartString();
  }

  Future<void> init() async {
    try {
      final List<Future<String>> assetFutures = [
        copyAssets(Assets.models.detV4),
        copyAssets(Assets.models.clsAngV4),
        copyAssets(Assets.models.sRAQatInt8),
        copyAssets(Assets.models.config),
        copyAssets(Assets.models.jpDict6861),
      ];

      final List<String> assetPaths = await Future.wait(assetFutures);

      _initOcrPipeline(
        detModelDir: assetPaths[0],
        clsModelDir: assetPaths[1],
        recModelDir: assetPaths[2],
        configPath: assetPaths[3],
        dictPath: assetPaths[4],
      );
    } catch (e) {
      Logger.log('Failed to initialize OCR pipeline: $e');
    }
  }

  Future<String> copyAssets(String assetPath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(assetPath);
    final String appDocPath = appDocDir.path;
    final String newPath = path.join(appDocPath, fileName);
    final File newFile = File(newPath);

    final byteData = await rootBundle.load(assetPath);
    await newFile.writeAsBytes(byteData.buffer.asUint8List());
    return newFile.path;
  }
}
