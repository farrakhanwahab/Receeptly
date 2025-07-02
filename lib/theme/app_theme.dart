import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color textColorSecondary = Colors.black54;
  static const Color textColorLight = Colors.grey;
  static const Color borderColor = Colors.black;
  static const Color dividerColor = Colors.grey;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;

  // Receipt Style Colors
  static const Color bankStyleColor = Colors.blue;
  static const Color restaurantStyleColor = Colors.orange;
  static const Color retailStyleColor = Colors.green;
  static const Color documentStyleColor = Colors.purple;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border Radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;

  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeXXXL = 24.0;

  // Text Styles
  static TextStyle get headingLarge => GoogleFonts.montserrat(
        fontSize: fontSizeXXXL,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle get headingMedium => GoogleFonts.montserrat(
        fontSize: fontSizeXXL,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  static TextStyle get headingSmall => GoogleFonts.montserrat(
        fontSize: fontSizeXL,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: fontSizeL,
        color: textColor,
      );

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: fontSizeM,
        color: textColor,
      );

  static TextStyle get bodySmall => GoogleFonts.montserrat(
        fontSize: fontSizeS,
        color: textColor,
      );

  static TextStyle get bodyXSmall => GoogleFonts.montserrat(
        fontSize: fontSizeXS,
        color: textColor,
      );

  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: fontSizeS,
        color: textColorSecondary,
      );

  static TextStyle get button => GoogleFonts.montserrat(
        fontSize: fontSizeL,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      );

  static TextStyle get label => GoogleFonts.montserrat(
        fontSize: fontSizeM,
        color: textColorSecondary,
      );

  // Receipt Text Styles
  static TextStyle get receiptTitle => GoogleFonts.montserrat(
        fontSize: fontSizeXXL,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle get receiptSubtitle => GoogleFonts.montserrat(
        fontSize: fontSizeM,
        color: textColor,
      );

  static TextStyle get receiptBody => GoogleFonts.montserrat(
        fontSize: fontSizeS,
        color: textColor,
      );

  static TextStyle get receiptTotal => GoogleFonts.montserrat(
        fontSize: fontSizeL,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle get receiptItem => GoogleFonts.montserrat(
        fontSize: fontSizeS,
        color: textColor,
      );

  // Input Decoration
  static InputDecoration get inputDecoration => InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        labelStyle: label,
        hintStyle: caption,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
      );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        textStyle: button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        textStyle: button.copyWith(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          side: const BorderSide(color: primaryColor),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      );

  static ButtonStyle get dangerButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: errorColor,
        foregroundColor: secondaryColor,
        textStyle: button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      );

  // Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(borderRadiusM),
        border: Border.all(color: dividerColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get selectedCardDecoration => BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(borderRadiusM),
        border: Border.all(color: primaryColor, width: 2),
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        titleTextStyle: headingMedium,
        iconTheme: const IconThemeData(color: textColor),
      );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColorLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  // Divider Theme
  static DividerThemeData get dividerTheme => const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: spacingM,
      );

  // Icon Theme
  static IconThemeData get iconTheme => const IconThemeData(
        color: textColor,
        size: 24,
      );

  // Slider Theme
  static SliderThemeData get sliderTheme => SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: dividerColor,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
        valueIndicatorColor: primaryColor,
        valueIndicatorTextStyle: bodySmall.copyWith(color: secondaryColor),
      );

  // Snackbar Theme
  static SnackBarThemeData get snackBarTheme => const SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: TextStyle(color: secondaryColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusM)),
        ),
      );

  // Popup Menu Theme
  static PopupMenuThemeData get popupMenuTheme => PopupMenuThemeData(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
        elevation: 8,
      );

  // List Tile Theme
  static ListTileThemeData get listTileTheme => const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
        titleTextStyle: TextStyle(
          fontSize: fontSizeL,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: fontSizeS,
          color: textColorSecondary,
        ),
      );

  // Main Theme Data
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        appBarTheme: appBarTheme,
        bottomNavigationBarTheme: bottomNavigationBarTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor),
          ),
          labelStyle: label,
          hintStyle: caption,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
        ),
        dividerTheme: dividerTheme,
        iconTheme: iconTheme,
        sliderTheme: sliderTheme,
        snackBarTheme: snackBarTheme,
        popupMenuTheme: popupMenuTheme,
        listTileTheme: listTileTheme,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        appBarTheme: appBarTheme,
        bottomNavigationBarTheme: bottomNavigationBarTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: borderColor),
          ),
          labelStyle: label,
          hintStyle: caption,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
        ),
        dividerTheme: dividerTheme,
        iconTheme: iconTheme,
        sliderTheme: sliderTheme,
        snackBarTheme: snackBarTheme,
        popupMenuTheme: popupMenuTheme,
        listTileTheme: listTileTheme,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.montserratTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
        appBarTheme: appBarTheme.copyWith(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(color: Colors.white),
          ),
          labelStyle: label.copyWith(color: Colors.white70),
          hintStyle: caption.copyWith(color: Colors.white54),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
        ),
        dividerTheme: dividerTheme.copyWith(color: Colors.white24),
        iconTheme: iconTheme.copyWith(color: Colors.white),
        sliderTheme: sliderTheme.copyWith(activeTrackColor: Colors.white),
        snackBarTheme: snackBarTheme.copyWith(backgroundColor: Colors.white, contentTextStyle: const TextStyle(color: Colors.black)),
        popupMenuTheme: popupMenuTheme.copyWith(color: Colors.black),
        listTileTheme: listTileTheme.copyWith(
          titleTextStyle: listTileTheme.titleTextStyle?.copyWith(color: Colors.white),
          subtitleTextStyle: listTileTheme.subtitleTextStyle?.copyWith(color: Colors.white70),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[900],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
        ),
      );
} 