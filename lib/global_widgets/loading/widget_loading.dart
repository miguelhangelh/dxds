import 'package:appdriver/core/utils/colors.dart';
import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor:  AlwaysStoppedAnimation<Color>(primaryColor),
      ),
    );
  }
}
