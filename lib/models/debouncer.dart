import 'package:flutter/material.dart';
import 'dart:async';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(seconds: 2)});

  void run(VoidCallback callback){
    if(_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() => _timer?.cancel();
}