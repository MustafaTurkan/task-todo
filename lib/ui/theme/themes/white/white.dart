import 'package:flutter/material.dart';
import 'package:todo/ui/theme/app_theme_data.dart';
import 'package:todo/ui/theme/iapp_colors.dart';
import 'package:todo/ui/theme/iapp_text_styles.dart';
import 'package:todo/ui/theme/theme_utils.dart';

class WhiteThemeColors extends IAppColors {
  //primartPale 0xffE8F0FE
  @override
  Color get accent => Color(0xff03469f); //0xff003F8C
  @override
  Color get canvasDark => Color(0xffE5E5E5);
  @override
  Color get canvas => Color(0xffF1F3F4); //F8F6F6 , F2F2F2
  @override
  Color get canvasLight => Color(0xffffffff);
  @override
  Color get disabled => Color(0xff80868B);
  @override
  Color get divider => Color(0xffDADCE0);
  @override
  Color get success => Color(0xff3dc954);
  @override
  Color get error => Color(0xfff54d53);
  @override
  Color get warning => Color(0xfff47d34);
  @override
  Color get info => primary;
  @override
  Color get fontDark => Color(0xff3b3e43);
  @override
  Color get font => Color(0xff5F6368);
  @override
  Color get fontPale => Color(0xff80868B);
  @override
  Color get fontLight => Color(0xffffffff);
  @override
  Color get primary => Color(0xff1a73e9);
  @override
  Color get primaryPale => primary.withOpacity(0.7);
  @override
  Color get unselectedWidgetColor => Color(0xff80868B);
  @override
  Color get toggleableActiveColor => primary;
  //Inkwell
  @override
  Color get splash => Color(0xffa9cbf7).withOpacity(0.5);
  @override
  Color get highlight => Color(0xffa9cbf7).withOpacity(0.3);
}

class WhiteThemeTextStyles extends IAppTextStyles {
  WhiteThemeTextStyles(this.data, this.colors);
  ThemeData data;
  IAppColors colors;
  @override
  TextStyle get emptyBackroundHint => data.textTheme.headline6.copyWith(color: colors.primary.withOpacity(0.3));
  

  


}

AppThemeData buildWhiteTheme(BuildContext context) {
  //appbar spesific copy
  TextTheme _appBarTextTheme(
    TextTheme base,
    Color color,
    String fontFamily,
  ) {
    return ThemeUtils.textThemeCopyWith(base, color, fontFamily).copyWith(
      headline6: base.headline6.copyWith(
        color: color,
        fontSize: base.headline6.fontSize,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      ),
    );
  }

  var fontFamily = 'Roboto';
  var buttonBorderRadius = BorderRadius.circular(5);
  var textBorderRadius = BorderRadius.circular(5);
  var cardBorderRadius = BorderRadius.circular(5);
  var appColors = WhiteThemeColors();
  var baseTheme = Theme.of(context);
  var newTheme = ThemeData(
    fontFamily: fontFamily,
    primaryColor: appColors.primary,
    primaryColorLight: appColors.primary,
    primaryColorDark: appColors.primary,
    primaryColorBrightness: Brightness.dark,
    accentColor: appColors.accent,
    accentColorBrightness: Brightness.dark,
    canvasColor: appColors.canvasLight,
    scaffoldBackgroundColor: appColors.canvas,
    highlightColor: appColors.highlight,
    splashColor: appColors.splash,
    dialogBackgroundColor: appColors.canvasLight,
    errorColor: appColors.error,
    indicatorColor: appColors.primary,
    cursorColor: appColors.primary,
    unselectedWidgetColor: appColors.unselectedWidgetColor,
    toggleableActiveColor: appColors.toggleableActiveColor,

    toggleButtonsTheme: ToggleButtonsThemeData(
      constraints: BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension * 0.8),
      borderRadius: buttonBorderRadius,
      color: appColors.font,
      selectedColor: appColors.primary,
      disabledColor: appColors.disabled,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 0.5,
    ),

    chipTheme: ChipThemeData.fromDefaults(
      labelStyle: baseTheme.textTheme.bodyText2,
      primaryColor: appColors.primary,
      secondaryColor: Color(0xffe8600d),
    ),
    textSelectionHandleColor: appColors.primary,
    popupMenuTheme: PopupMenuThemeData(elevation: 0.5),
    floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0.5,backgroundColor: appColors.primary),
    dividerTheme: DividerThemeData(color: appColors.divider, space: 1, indent: 10, endIndent: 10),
    tabBarTheme: TabBarTheme(
      labelStyle:baseTheme.textTheme.bodyText2.copyWith(color: appColors.font,fontSize:15),
      unselectedLabelStyle: baseTheme.textTheme.bodyText2.copyWith(color: appColors.font)
    ),

    appBarTheme: AppBarTheme(
      
      iconTheme: IconThemeData(color: appColors.fontLight),
      textTheme: _appBarTextTheme(baseTheme.primaryTextTheme, appColors.fontLight, fontFamily),
      color: appColors.canvasLight,
      elevation: 0.5,
      brightness: Brightness.light,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: appColors.canvasLight,
      elevation: 1,
    ),
    
    buttonTheme: NButtonThemeData(
      highlightColor: Colors.white24,
      splashColor: Colors.white30,
      raisedButtonElevation: 1,
      buttonColor: appColors.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.all(2),
      color: appColors.canvasLight,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
    ),
    snackBarTheme: SnackBarThemeData(
        contentTextStyle: baseTheme.textTheme.bodyText2.copyWith(color: appColors.fontLight),
        backgroundColor: appColors.primary,
        elevation: 4,
        actionTextColor: appColors.fontLight),

    textTheme: ThemeUtils.textThemeCopyWith(baseTheme.textTheme, appColors.font, fontFamily),
    primaryTextTheme: ThemeUtils.textThemeCopyWith(baseTheme.primaryTextTheme, appColors.fontLight, fontFamily),
    accentTextTheme: ThemeUtils.textThemeCopyWith(baseTheme.accentTextTheme, appColors.fontLight, fontFamily),
    inputDecorationTheme: InputDecorationTheme(
    
      labelStyle: TextStyle(color: appColors.font),
      hintStyle: TextStyle(color: appColors.fontPale.withOpacity(0.7)),
      helperStyle: TextStyle(color: appColors.fontPale),
      prefixStyle: TextStyle(color: appColors.fontPale),
      suffixStyle: TextStyle(color: appColors.fontPale),
      counterStyle: TextStyle(color: appColors.fontPale),
      errorStyle: TextStyle(color: appColors.error.withOpacity(0.7)),
      contentPadding: EdgeInsets.all(10),
      
      fillColor: Color(0xFFf2f6fd),
      filled: true,
      isDense: true,
      border: ThemeUtils.inputBorder(
        appColors.canvasDark,
        textBorderRadius,
      ),
      focusedBorder: ThemeUtils.inputBorder(
        appColors.primary.withOpacity(0.3),
        textBorderRadius,
      ),
      enabledBorder: ThemeUtils.inputBorder(
        appColors.canvasDark,
        textBorderRadius,
      ),
      errorBorder: ThemeUtils.inputBorder(
        appColors.error.withOpacity(0.3),
        textBorderRadius,
      ),
      focusedErrorBorder: ThemeUtils.inputBorder(
        appColors.error.withOpacity(0.5),
        textBorderRadius,
      ),
      disabledBorder: ThemeUtils.inputBorder(
        appColors.disabled.withOpacity(0.5),
        textBorderRadius,
      ),
    ),
    // snackBarTheme: baseTheme.snackBarTheme.copyWith(
    //     contentTextStyle: baseTheme.snackBarTheme.contentTextStyle
    //         .copyWith(color: appColors.fontDark)),
    colorScheme: ColorScheme(
      background: appColors.canvas,
      brightness: Brightness.light,
      error: appColors.error,
      primary: appColors.primary,
      primaryVariant: appColors.primary,
      secondary: appColors.accent,
      secondaryVariant: appColors.accent,
      surface: appColors.canvas,
      onBackground: appColors.font,
      onError: appColors.fontLight,
      onPrimary: appColors.fontLight,
      onSecondary: appColors.fontLight,
      onSurface: appColors.font,
    ),

    primaryIconTheme: IconThemeData(color: appColors.canvasLight),
    accentIconTheme: IconThemeData(color: appColors.canvasLight),
    iconTheme: IconThemeData(color: appColors.primary),
    //use cupertino slide effect
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    

  );

  return AppThemeData(newTheme, appColors, WhiteThemeTextStyles(newTheme, appColors));
}


