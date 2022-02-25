import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EmptyDataMessage extends StatelessWidget {
  final String? message;
  final VoidCallback? onPressed;
  const EmptyDataMessage({Key? key, this.message, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: primaryColor,
            size: 50,
          ),
          CustomSubTitleWidget(
            textAlign: TextAlign.center,
            maxLines: 5,
            text: message,
            color: Colors.black,
            size: 16.0.sp,
            //13px
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Text(
              '(Reintentar)',
              style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
            ),
            onTap: onPressed,
          )
        ],
      ),
    );
  }
}
