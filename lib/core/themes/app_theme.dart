import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/font_styles.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static Color lightBackgroundColor = const Color(0xFFFFFFFF);
  static Color lightPrimaryColor = const Color(0xFFFFFFFF);
  static Color lightAccentColor = Colors.blueGrey.shade200;

  static Color darkBackgroundColor = const Color(0xFF1A2127);
  static Color darkPrimaryColor = const Color(0xFF1A2127);
  static Color darkAccentColor = Colors.blueGrey.shade600;
  static MaterialColor colorCustom = const MaterialColor(0xffEC8105, color);

  const AppTheme._();

  static final lightTheme = ThemeData(
    toggleableActiveColor: primaryColor,
    textTheme: FontStyles.textTheme.copyWith(
      subtitle1: TextStyle(fontSize: 12.0.sp),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white, // For both Android + iOS

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 18.0.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: primaryColor),
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch(accentColor: primaryColor, primarySwatch: colorCustom, primaryColorDark: primaryColor),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12.0.sp,
        color: const Color.fromRGBO(0, 0, 0, 0.6),
      ),

      hintStyle: TextStyle(fontSize: 10.0.sp),
      //  hintStyle: GoogleFonts.montserrat(
      //   fontSize: 16,
      //   color: const Color(0xFF000)
      // ),
      contentPadding: const EdgeInsets.fromLTRB(18.5, 18.5, 18.5, 18.5),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color:  Color(0xffEC8105),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color:  Color(0xffe0e0e0),
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color:  Color(0xffe0e0e0),
          width: 1,
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    backgroundColor: lightBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final darkTheme = ThemeData(
    textTheme: FontStyles.textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: darkPrimaryColor,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 16),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0), width: 1)),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffe0e0e0), width: 1),
      ),
    ),
    primaryColor: darkPrimaryColor,
    backgroundColor: darkBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static Brightness get currentSystemBrightness => SchedulerBinding.instance!.window.platformBrightness;

  static setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: themeMode == ThemeMode.light ? Colors.black : darkBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
  }
}
