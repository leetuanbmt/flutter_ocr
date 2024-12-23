import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ocr/logger.dart';
import 'package:image_picker/image_picker.dart';

import 'core/constants/assets.gen.dart';
import 'core/models/ocr_pipeline.dart';
import 'core/models/ocr_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late OcrResult result;

  late final OcrPipeline ocrPipeline;

  final ImagePicker picker = ImagePicker();

  Future<void> initializeLib() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    try {
      result = ocrPipeline.process(image.path);
      Logger.log(result.texts);
    } catch (e) {
      Logger.log(e);
    } finally {
      ocrPipeline.dispose();
    }
  }

  Future<void> _initialize() async {
    final detModelDir = await copyAssets(Assets.models.detV4);
    final clsModelDir = await copyAssets(Assets.models.clsAngV4);
    final recModelDir =
        await copyAssets(Assets.models.lightweightHandwrittingSRAQatInt8);
    final configPath = await copyAssets(Assets.models.config);
    final dictPath = await copyAssets(Assets.models.jpDict6861);
    ocrPipeline = OcrPipeline(
      detModelDir: detModelDir,
      clsModelDir: clsModelDir,
      recModelDir: recModelDir,
      configPath: configPath,
      dictPath: dictPath,
    );
    Logger.log('Initialized $ocrPipeline');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: initializeLib, child: const Text('OCR')),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Show Result'),
            ),
          ],
        ),
      ),
    );
  }
}

Iterable<String> toStringList(Pointer<Pointer<Utf8>> charPointerPointer) sync* {
  int index = 0;
  while (true) {
    final charPointer = charPointerPointer[index];
    if (charPointer == nullptr) {
      break;
    }
    yield charPointer.toDartString();
    index++;
  }
}

Future<String> copyAssets(String assetPath) async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final fileName = path.basename(assetPath);
  final String appDocPath = appDocDir.path;
  final String newPath = path.join(appDocPath, fileName);
  final File newFile = File(newPath);

  final ByteData byteData = await rootBundle.load(assetPath);
  await newFile.writeAsBytes(byteData.buffer.asUint8List());
  return newPath;
}
