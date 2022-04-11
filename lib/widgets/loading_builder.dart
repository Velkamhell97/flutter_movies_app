import 'package:flutter/material.dart';

class LoadingBuilder extends StatelessWidget {
  final double posterHeight;

  const LoadingBuilder({Key? key, required this.posterHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: posterHeight,
      width: double.infinity,
      child: const Align(child: CircularProgressIndicator()),
    );
  }
}