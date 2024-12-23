import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr/logger.dart';
import 'package:image_picker/image_picker.dart';

import 'models/ocr_pipeline.dart';
import 'models/result.dart';

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
  final ocrPipeline = OcrPipeline();
  final ImagePicker picker = ImagePicker();
  Future<void> initializeLib() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    try {
      result = await ocrPipeline.process(image.path);
      Logger.log(result.texts);
    } catch (e) {
      Logger.log(e);
    } finally {
      ocrPipeline.dispose();
    }
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
