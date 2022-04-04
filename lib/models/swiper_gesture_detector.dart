import 'package:flutter/gestures.dart';

class SwiperGestureDetector extends OneSequenceGestureRecognizer {
  final Function onMove;
  final Function onUp;
  final Function onDown;

  SwiperGestureDetector({required this.onMove, required this.onUp, required this.onDown});
 
  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if(event is PointerMoveEvent){
      onMove();
    }
    if(event is PointerUpEvent){
      resolve(GestureDisposition.accepted);
      onUp();
    }
    if(event is PointerDownEvent) {
      onDown();
    }
  }

  @override
  String get debugDescription => 'Custom gestures';
}