import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

abstract class Dialogs {
  static Future<void> alert(
    BuildContext context, {
    String? title,
    String? description,
    String message = '',
    Widget? itemCustom,
    String okText = "OK",
    bool dismissible = false,
    VoidCallback? onPressed,
  }) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => WillPopScope(
        onWillPop: () async => dismissible,
        child: CupertinoAlertDialog(
            title: title != null
                ? CustomTitleWidget(
                    title: title,
                    size: 14.sp,
                    fontWeight: FontWeight.w600,
                  )
                : null,
            content: description != null
                ? CustomTitleWidget(
                    title: description,
                    padding:  EdgeInsets.zero,
                    size: 10.0.sp,
                    fontWeight: FontWeight.w400,
                  )
                : null,
            actions: itemCustom != null
                ? [
                    itemCustom,
                    CupertinoDialogAction(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      onPressed: onPressed ?? () => Navigator.pop(context),
                      child: Text(okText),
                    )
                  ]
                : [
                    CupertinoDialogAction(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      onPressed: onPressed ?? () => Navigator.pop(context),
                      child: Text(okText),
                    ),
                  ]),
      ),
    );
  }
}

abstract class ProgressDialog {
  static Future<void> show(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: Colors.white30,
          child: CupertinoActivityIndicator(
            radius: 15,
          ),
        ),
      ),
    );
  }
}

abstract class ModalBottomSheet {
  static Future<void> show({required BuildContext context, List<Widget>? children, double border = 38, bool isScrollControlled = false}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(border), topRight: Radius.circular(border)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            // padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30, bottom: 30),
            child: Container(
              padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children!,
              ),
            ),
          );
        });
  }
}

abstract class SnackBarWidget {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({required BuildContext context, String description: ''}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.redAccent,
        content: Padding(
          padding: const EdgeInsets.all(
            10.0,
          ),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: Duration(
          seconds: 5,
        ),
        // action: SnackBarAction(
        //   label: 'X',
        //   textColor: Colors.white,
        //   onPressed: () {},
        // ),
      ),
    );
  }
}
