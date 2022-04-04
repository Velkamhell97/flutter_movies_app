import 'package:flutter/gestures.dart';

class SwiperGestureDetectorCopy extends OneSequenceGestureRecognizer {
  final Function onMove;
  final Function onUp;

  SwiperGestureDetectorCopy({required this.onMove, required this.onUp});
 
  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if(event is PointerMoveEvent){
      onMove();
    }
    if(event is PointerUpEvent){
      resolve(GestureDisposition.rejected);
      onUp();
    }
  }

  @override
  String get debugDescription => 'Custom gestures';
}