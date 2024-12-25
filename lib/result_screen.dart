import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'core/models/ocr_result.dart';

class ResultScreen extends HookWidget {
  const ResultScreen({
    super.key,
    required this.result,
    required this.imagePath,
  });
  final OCRResult result;

  final String imagePath;

  Size get sizeImage => result.sizeImage;

  double getScaleFactor(BoxConstraints constraints) {
    final size =
        constraints.constrainSizeAndAttemptToPreserveAspectRatio(sizeImage);

    return size.width / sizeImage.width;
  }

  @override
  Widget build(BuildContext context) {
    final items = result.results ?? [];
    final isVisibleImage = useState(true);
    final isVisibleResult = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          IconButton(
            onPressed: () {
              isVisibleImage.value = !isVisibleImage.value;
            },
            icon: Icon(
              isVisibleImage.value ? Icons.image : Icons.image_not_supported,
            ),
          ),
          IconButton(
            onPressed: () {
              isVisibleResult.value = !isVisibleResult.value;
            },
            icon: Icon(
              isVisibleResult.value ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double scaleFactor = getScaleFactor(constraints);
            return SizedBox(
              width: sizeImage.width * scaleFactor,
              height: sizeImage.height * scaleFactor,
              child: Stack(
                children: [
                  Visibility(
                    visible: isVisibleImage.value,
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  ...items.map(
                    (item) {
                      final topLeft =
                          item.topLeft.scale(scaleFactor, scaleFactor);

                      final bottomRight =
                          item.bottomRight.scale(scaleFactor, scaleFactor);

                      final width = bottomRight.dx - topLeft.dx;

                      final height = bottomRight.dy - topLeft.dy;

                      return Visibility(
                        visible: isVisibleResult.value,
                        child: Positioned(
                          top: topLeft.dy - 1,
                          left: topLeft.dx - 1,
                          child: SizedBox(
                            width: width + 2,
                            height: height + 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                color: isVisibleImage.value
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.transparent,
                              ),
                              child: FittedBox(
                                child: SelectableText(
                                  item.text ?? '',
                                  style: TextStyle(
                                    color: isVisibleImage.value
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
