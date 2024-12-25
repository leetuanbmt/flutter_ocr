import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../logger.dart';
import '../constants/assets.gen.dart';
import '../models/ocr_result.dart';
import 'ocr_bindings.dart';

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
            final result = OcrBindings.processImage(data.imagePath);
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

  Future<OCRResult?> processOcrImage(String imagePath) async {
    await init();
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

  Future<void> init() async {
    // if (isInitialized) {
    //   return;
    // }
    try {
      final List<Future<String>> assetFutures = [
        copyAssets(Assets.models.detV4),
        copyAssets(Assets.models.sRAQatInt8),
        copyAssets(Assets.models.config),
      ];

      final List<String> assetPaths = await Future.wait(assetFutures);
      isInitialized = OcrBindings.initPipeline(
        detModelDir: assetPaths[0],
        recModelDir: assetPaths[1],
        cPUPowerMode: 'LITE_POWER_HIGH',
        cPUThreadNum: 1,
        configPath: assetPaths[2],
      );
      Logger.log('OCR pipeline initialized: $isInitialized');
    } catch (e) {
      Logger.log('Failed to initialize OCR pipeline: $e');
    }
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
