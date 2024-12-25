// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OCRResult _$OCRResultFromJson(Map<String, dynamic> json) {
  return _OCRResult.fromJson(json);
}

/// @nodoc
mixin _$OCRResult {
  List<Results>? get results => throw _privateConstructorUsedError;

  /// Serializes this OCRResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OCRResultCopyWith<OCRResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OCRResultCopyWith<$Res> {
  factory $OCRResultCopyWith(OCRResult value, $Res Function(OCRResult) then) =
      _$OCRResultCopyWithImpl<$Res, OCRResult>;
  @useResult
  $Res call({List<Results>? results});
}

/// @nodoc
class _$OCRResultCopyWithImpl<$Res, $Val extends OCRResult>
    implements $OCRResultCopyWith<$Res> {
  _$OCRResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = freezed,
  }) {
    return _then(_value.copyWith(
      results: freezed == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Results>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OCRResultImplCopyWith<$Res>
    implements $OCRResultCopyWith<$Res> {
  factory _$$OCRResultImplCopyWith(
          _$OCRResultImpl value, $Res Function(_$OCRResultImpl) then) =
      __$$OCRResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Results>? results});
}

/// @nodoc
class __$$OCRResultImplCopyWithImpl<$Res>
    extends _$OCRResultCopyWithImpl<$Res, _$OCRResultImpl>
    implements _$$OCRResultImplCopyWith<$Res> {
  __$$OCRResultImplCopyWithImpl(
      _$OCRResultImpl _value, $Res Function(_$OCRResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = freezed,
  }) {
    return _then(_$OCRResultImpl(
      results: freezed == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Results>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OCRResultImpl implements _OCRResult {
  const _$OCRResultImpl({final List<Results>? results}) : _results = results;

  factory _$OCRResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OCRResultImplFromJson(json);

  final List<Results>? _results;
  @override
  List<Results>? get results {
    final value = _results;
    if (value == null) return null;
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OCRResult(results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OCRResultImpl &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_results));

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OCRResultImplCopyWith<_$OCRResultImpl> get copyWith =>
      __$$OCRResultImplCopyWithImpl<_$OCRResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OCRResultImplToJson(
      this,
    );
  }
}

abstract class _OCRResult implements OCRResult {
  const factory _OCRResult({final List<Results>? results}) = _$OCRResultImpl;

  factory _OCRResult.fromJson(Map<String, dynamic> json) =
      _$OCRResultImpl.fromJson;

  @override
  List<Results>? get results;

  /// Create a copy of OCRResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OCRResultImplCopyWith<_$OCRResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Results _$ResultsFromJson(Map<String, dynamic> json) {
  return _Results.fromJson(json);
}

/// @nodoc
mixin _$Results {
  ///top left, top right, bot right, bot left
  List<List<int>>? get box => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;

  /// Serializes this Results to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Results
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultsCopyWith<Results> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultsCopyWith<$Res> {
  factory $ResultsCopyWith(Results value, $Res Function(Results) then) =
      _$ResultsCopyWithImpl<$Res, Results>;
  @useResult
  $Res call({List<List<int>>? box, double? confidence, String? text});
}

/// @nodoc
class _$ResultsCopyWithImpl<$Res, $Val extends Results>
    implements $ResultsCopyWith<$Res> {
  _$ResultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Results
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? box = freezed,
    Object? confidence = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      box: freezed == box
          ? _value.box
          : box // ignore: cast_nullable_to_non_nullable
              as List<List<int>>?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResultsImplCopyWith<$Res> implements $ResultsCopyWith<$Res> {
  factory _$$ResultsImplCopyWith(
          _$ResultsImpl value, $Res Function(_$ResultsImpl) then) =
      __$$ResultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<List<int>>? box, double? confidence, String? text});
}

/// @nodoc
class __$$ResultsImplCopyWithImpl<$Res>
    extends _$ResultsCopyWithImpl<$Res, _$ResultsImpl>
    implements _$$ResultsImplCopyWith<$Res> {
  __$$ResultsImplCopyWithImpl(
      _$ResultsImpl _value, $Res Function(_$ResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Results
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? box = freezed,
    Object? confidence = freezed,
    Object? text = freezed,
  }) {
    return _then(_$ResultsImpl(
      box: freezed == box
          ? _value._box
          : box // ignore: cast_nullable_to_non_nullable
              as List<List<int>>?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResultsImpl extends _Results {
  const _$ResultsImpl({final List<List<int>>? box, this.confidence, this.text})
      : _box = box,
        super._();

  factory _$ResultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResultsImplFromJson(json);

  ///top left, top right, bot right, bot left
  final List<List<int>>? _box;

  ///top left, top right, bot right, bot left
  @override
  List<List<int>>? get box {
    final value = _box;
    if (value == null) return null;
    if (_box is EqualUnmodifiableListView) return _box;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? confidence;
  @override
  final String? text;

  @override
  String toString() {
    return 'Results(box: $box, confidence: $confidence, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultsImpl &&
            const DeepCollectionEquality().equals(other._box, _box) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_box), confidence, text);

  /// Create a copy of Results
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultsImplCopyWith<_$ResultsImpl> get copyWith =>
      __$$ResultsImplCopyWithImpl<_$ResultsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResultsImplToJson(
      this,
    );
  }
}

abstract class _Results extends Results {
  const factory _Results(
      {final List<List<int>>? box,
      final double? confidence,
      final String? text}) = _$ResultsImpl;
  const _Results._() : super._();

  factory _Results.fromJson(Map<String, dynamic> json) = _$ResultsImpl.fromJson;

  ///top left, top right, bot right, bot left
  @override
  List<List<int>>? get box;
  @override
  double? get confidence;
  @override
  String? get text;

  /// Create a copy of Results
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultsImplCopyWith<_$ResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
