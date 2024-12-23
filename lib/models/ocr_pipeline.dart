import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ocr/logger.dart';
import 'package:flutter_ocr/models/result.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/assets.gen.dart';

typedef ProcessNative = OcrResult Function(Pointer<Void>, Pointer<Utf8>);

typedef ProcessDart = OcrResult Function(Pointer<Utf8>);

typedef CreatePipe = Pointer<Void> Function(
  Pointer<Utf8>,
  Pointer<Utf8>,
  Pointer<Utf8>,
  Pointer<Utf8>,
  Int32,
  Pointer<Utf8>,
  Pointer<Utf8>,
);

class OcrPipeline {
  late final DynamicLibrary _pipelineLib;
  late final ProcessDart _process;
  Pointer<Void>? _pipeline;
  late final CreatePipe _createPipeline;
  OcrPipeline() {
    _pipelineLib = Platform.isAndroid
        ? DynamicLibrary.open('libpipeline.so')
        : DynamicLibrary.process();

    _process =
        _pipelineLib.lookup<NativeFunction<ProcessDart>>('system').asFunction();
  }

  Future<OcrResult> process(String imagePath) async {
    final detV4 = await copyFileToStorage(Assets.models.detV4);
    final lightweightHandwrittingSRAQatInt8 = await copyFileToStorage(
      Assets.models.lightweightHandwrittingSRAQatInt8,
    );

    final clsAngV4 = await copyFileToStorage(Assets.models.clsAngV4);
    final config = await copyFileToStorage(Assets.models.config);
    final jpDict6861 = await copyFileToStorage(Assets.models.jpDict6861);
    final configProcess = Configs(
      detModelDir: detV4,
      recModelDir: lightweightHandwrittingSRAQatInt8,
      clsModelDir: clsAngV4,
      imagePath: imagePath,
      configPath: config,
      dictPath: jpDict6861,
      batchSize: 1,
    );
    Logger.log(configProcess.toString());
    final imagePathPtr = configProcess.toString().toNativeUtf8();
    final result = _process(imagePathPtr);
    calloc.free(imagePathPtr);
    return result;
  }

  void dispose() {
    if (_pipeline != null) {
      _pipeline = null;
    }
  }
}

Future<String> copyFileToStorage(String assetPath) async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final fileName = path.basename(assetPath);
  final String appDocPath = appDocDir.path;
  final String newPath = path.join(appDocPath, fileName);
  final File newFile = File(newPath);

  final ByteData byteData = await rootBundle.load(assetPath);
  await newFile.writeAsBytes(byteData.buffer.asUint8List());
  return newPath;
}

class Configs {
  final String detModelDir;
  final String clsModelDir;
  final String recModelDir;
  final String precision;
  final int cpuThreadNum;
  final String imagePath;
  final String configPath;
  final String dictPath;
  final String runtimeDevice;
  final int batchSize;

  Configs({
    required this.detModelDir,
    required this.clsModelDir,
    required this.recModelDir,
    this.precision = 'INT8',
    this.cpuThreadNum = 1,
    required this.imagePath,
    required this.configPath,
    required this.dictPath,
    this.runtimeDevice = 'CPU',
    this.batchSize = 1,
  });

  @override
  String toString() {
    return '''$detModelDir $recModelDir $clsModelDir
$runtimeDevice $precision $cpuThreadNum $batchSize $imagePath
$configPath $dictPath''';
  }
}
