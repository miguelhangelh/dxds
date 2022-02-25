import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

extension NavigatorExtension on Navigator {
  static pushAndRemoveUntil(Widget widget, BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Toca de nuevo para salir'),
              ),
              child: widget,
            ),
          ),
        ),
        (Route<dynamic> route) => false);
  }

  static pushAndRemoveUntilState(Widget widget, NavigatorState state) {
    state.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Toca de nuevo para salir'),
              ),
              child: widget,
            ),
          ),
        ),
        (Route<dynamic> route) => false);
  }
}
