// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OCRResultImpl _$$OCRResultImplFromJson(Map<String, dynamic> json) =>
    _$OCRResultImpl(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OCRResultImplToJson(_$OCRResultImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

_$ResultsImpl _$$ResultsImplFromJson(Map<String, dynamic> json) =>
    _$ResultsImpl(
      box: (json['box'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$ResultsImplToJson(_$ResultsImpl instance) =>
    <String, dynamic>{
      'box': instance.box,
      'confidence': instance.confidence,
      'text': instance.text,
    };
