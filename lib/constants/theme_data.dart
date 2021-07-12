import 'package:flutter/material.dart';

Color mainColor = Color(0xFF1B263B);
Color dividerColor = Color(0xFFE0E1DD);
Color textColor = Color(0xFFFFFFFF);
Color secondaryColor = Color(0xFF778DA9);

class GeneralTheme extends ChangeNotifier {
  ThemeData generalThemeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    primaryColor: mainColor,
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Color(0xFF778DA9),
    primaryColorDark: Color(0xFF415A77),
    canvasColor: Colors.white,
    accentColor: secondaryColor,
    accentColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor: mainColor,
    cardColor: mainColor,
    dividerColor: dividerColor,
    focusColor: Color(0xFF415A77),
    hoverColor: Color(0xFF1B263B),
    highlightColor: Color(0xFF1B263B),
    splashColor: Color(0xFF1B263B),
    selectedRowColor: Color(0xFF8d8b8b),
    disabledColor: dividerColor,
    buttonTheme: ButtonThemeData(
      minWidth: 60.0,
      height: 30,
      padding: EdgeInsets.all(10),
      buttonColor: mainColor,
      disabledColor: dividerColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      highlightColor: Color(0xFF1B263B),
      hoverColor: Color(0xFF415A77),
    ),
    buttonColor: mainColor,
    backgroundColor: Colors.white,
    dialogBackgroundColor: Colors.black87,
    indicatorColor: mainColor,
    hintColor: textColor,
    errorColor: Colors.red,
    toggleableActiveColor: Color(0xFF415A77),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: textColor,
        fontSize: 25.0,
        fontFamily: "Kalameh",
        fontWeight: FontWeight.w700,
      ),
      headline2: TextStyle(
        color: textColor,
        fontSize: 20.0,
        fontFamily: "Kalameh",
        fontWeight: FontWeight.w500,
      ),
    ),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(
        color: textColor,
        fontSize: 50.0,
        fontFamily: "IRANSans",
        fontWeight: FontWeight.w700,
        letterSpacing: 20,
      ),
      headline2: TextStyle(
        color: textColor,
        fontSize: 30.0,
        fontFamily: "IRANSans",
        fontWeight: FontWeight.w500,
      ),
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(
        color: textColor,
        fontSize: 20.0,
        fontFamily: "Kalameh",
        fontWeight: FontWeight.w700,
      ),
      headline2: TextStyle(
        color: textColor,
        fontSize: 13.0,
        fontFamily: "Kalameh",
        fontWeight: FontWeight.w500,
      ),
    ),
    primaryIconTheme: IconThemeData(
      color: secondaryColor,
      size: 15.0,
      opacity: 10.0,
    ),
    // accentIconTheme: IconThemeData(
    //   color: secondaryColor,
    //   size: 15.0,
    //   opacity: 10.0,
    // ),
    sliderTheme: SliderThemeData(
      activeTrackColor: mainColor,
      inactiveTrackColor: Colors.grey,
      thumbColor: Color(0xFF415A77),
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white70,
      labelColor: mainColor,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 16.0,
    ),
    appBarTheme: AppBarTheme(
      color: mainColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: secondaryColor,
        size: 15.0,
        opacity: 10.0,
      ),
    ),
    // colorScheme: ColorScheme(
    //   primary: mainColor,
    //   surface: secondaryColor,
    // ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black,
      actionTextColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: mainColor,
      hoverColor: Color(0xFF415A77),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(
        color: mainColor,
        size: 15.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: secondaryColor,
        size: 15.0,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: secondaryColor,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: dividerColor,
    ),
    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      buttonTextTheme: ButtonTextTheme.normal,
      buttonPadding: EdgeInsets.all(10.0),
    ),
    fontFamily: 'IRANSans',
  );

  ThemeData getTheme() {
    return generalThemeData;
  }
}
