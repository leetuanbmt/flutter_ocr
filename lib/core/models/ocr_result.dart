import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class OcrResult extends Struct {
  external Pointer<Pointer<Pointer<Int32>>> boxes;
  external Pointer<Pointer<Utf8>> texts;
  external Pointer<Float> scores;
}
