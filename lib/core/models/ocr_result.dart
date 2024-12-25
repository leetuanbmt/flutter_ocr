import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'ocr_result.freezed.dart';
part 'ocr_result.g.dart';

@freezed
class OCRResult with _$OCRResult {
  factory OCRResult.fromJson(Map<String, Object?> json) =>
      _$OCRResultFromJson(json);
  const OCRResult._();
  const factory OCRResult({
    List<Results>? results,
    @JsonKey(name: 'image_height') @Default(0) double height,
    @JsonKey(name: 'image_width') @Default(0) double width,
  }) = _OCRResult;

  Size get sizeImage => Size(width, height);
}

@freezed
class Results with _$Results {
  const Results._();
  const factory Results({
    ///top left, top right, bottom right, bottom left
    List<List<int>>? box,
    double? confidence,
    String? text,
  }) = _Results;

  factory Results.fromJson(Map<String, Object?> json) =>
      _$ResultsFromJson(json);

  Offset get topLeft => box![0].toOffset();

  Offset get topRight => box![1].toOffset();

  Offset get bottomRight => box![2].toOffset();

  Offset get bottomLeft => box![3].toOffset();

  List<Offset> get boxOffset => box!.map((e) => e.toOffset()).toList();
}

extension ListIntExtension on List<int> {
  Offset toOffset() => Offset(this[0].toDouble(), this[1].toDouble());
}
