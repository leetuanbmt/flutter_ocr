import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'core/models/ocr_result.dart';
import 'logger.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.result,
    required this.sizeImage,
    required this.imagePath,
  });
  final OCRResult result;
  final Size sizeImage;
  final String imagePath;

  double getScaleFactor(BoxConstraints constraints) {
    final size =
        constraints.constrainSizeAndAttemptToPreserveAspectRatio(sizeImage);

    return size.width / sizeImage.width;
  }

  Map<String, double> convertBox(List<Offset> box) {
    if (box.length != 4) {
      throw ArgumentError('The list of points must contain 4 points.');
    }

    double minX = box.map((e) => e.dx).reduce(min);
    double maxX = box.map((e) => e.dx).reduce(max);
    double minY = box.map((e) => e.dy).reduce(min);

    return {
      'left': minX,
      'top': minY,
      'width': maxX - minX,
      'height': box.map((e) => e.dy).reduce(max) - minY,
    };
  }

  @override
  Widget build(BuildContext context) {
    Logger.log('image size: $sizeImage');
    Logger.log('result: ${result.toJson()}');
    final items = result.results ?? [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Result'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double scaleFactor = getScaleFactor(constraints);
            Logger.log('ResultScreen: scaleFactor $scaleFactor');
            return Stack(
              children: [
                Image.file(
                  File(imagePath),
                  width: sizeImage.width * scaleFactor,
                  height: sizeImage.height * scaleFactor,
                ),
                ...items.map(
                  (item) {
                    final scaledTopLeft =
                        item.topLeft.scale(scaleFactor, scaleFactor);

                    final scaledBottomRight =
                        item.bottomRight.scale(scaleFactor, scaleFactor);

                    return Positioned(
                      top: scaledTopLeft.dy,
                      left: scaledTopLeft.dx,
                      child: Container(
                        width: scaledBottomRight.dx - scaledTopLeft.dx,
                        height: scaledBottomRight.dy - scaledTopLeft.dy,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            item.text ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OCRResultPainter extends CustomPainter {
  OCRResultPainter(this.results);
  final List<Results> results;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var result in results) {
      // Vẽ bounding box
      final path = Path();
      path.moveTo(result.box![0][0].toDouble(), result.box![0][1].toDouble());
      path.lineTo(result.box![1][0].toDouble(), result.box![1][1].toDouble());
      path.lineTo(result.box![2][0].toDouble(), result.box![2][1].toDouble());
      path.lineTo(result.box![3][0].toDouble(), result.box![3][1].toDouble());
      path.close();
      canvas.drawPath(path, paint);

      // Vẽ text
      final textPainter = TextPainter(
        text: TextSpan(
          text: result.text,
          style: const TextStyle(color: Colors.red, fontSize: 16.0),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(result.box![0][0].toDouble(), result.box![0][1].toDouble() - 20),
      );
    }
  }

  @override
  bool shouldRepaint(OCRResultPainter oldDelegate) {
    return oldDelegate.results != results;
  }
}
