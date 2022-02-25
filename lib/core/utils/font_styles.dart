import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
abstract class FontStyles {
  
  static final TextTheme textTheme = GoogleFonts.montserratTextTheme(

  );

  static final title = GoogleFonts.montserrat(
    fontSize: 22.0.sp,
    fontWeight: FontWeight.w600,
  );
  static final titleRegister = GoogleFonts.montserrat(
    fontSize: 24.0.sp,
    fontWeight: FontWeight.w600,
  );
  static final regular = GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
  );

  static final normal = GoogleFonts.montserrat(
    fontWeight: FontWeight.w300,
  );
}
