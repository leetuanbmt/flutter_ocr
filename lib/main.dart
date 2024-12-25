import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import 'core/models/ocr_result.dart';
import 'core/utils/ocr_pipeline.dart';
import 'logger.dart';
import 'result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Text Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> detectionText(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final ocrResult = await OcrPipeline().processOcrImage(image.path);
      _checkFinish(ocrResult, image);
    } catch (e) {
      Logger.log(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// After the OCR process is done, the result will be displayed in the ResultScreen
  void _checkFinish(OCRResult? ocrResult, XFile? image) {
    try {
      if (ocrResult == null || image == null) return;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: ocrResult,
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      Logger.log(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Text Detection'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => detectionText(ImageSource.gallery),
                  child: const Text('Choose image'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => detectionText(ImageSource.camera),
                  child: const Text('Take a photo'),
                ),
              ],
            ),
          ),
          if (isLoading) const LoadingIndicator(),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.2),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Size getSizeImage(String imagePath) {
  final File imageFile = File(imagePath);
  final bytes = imageFile.readAsBytesSync();
  final image = decodeImage(bytes);
  if (image == null) {
    return const Size(0, 0);
  }
  return Size(image.width.toDouble(), image.height.toDouble());
}
