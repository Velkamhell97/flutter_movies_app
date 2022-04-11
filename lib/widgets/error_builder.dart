import 'package:flutter/material.dart';

class ErrorBuilder extends StatelessWidget {
  final String error;
  final double posterHeight;
  final VoidCallback onTap;

  const ErrorBuilder({Key? key, required this.error, required this.posterHeight, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: posterHeight,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error),
            ElevatedButton(
              onPressed: onTap, 
              child: const Text('Reintentar')
            )
          ],
        ),
      ),
    );
  }
}