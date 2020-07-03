import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/ui/theme/app_theme_data.dart';
import 'package:todo/ui/theme/iapp_colors.dart';
import 'package:todo/ui/theme/iapp_text_styles.dart';




class AppTheme with ChangeNotifier {
  IAppColors _colors;
  IAppColors get colors => _colors;
  
  ThemeData _data;
  ThemeData get data => _data;

  IAppTextStyles _textStyles;
  IAppTextStyles get textStyles => _textStyles;

  bool get initialized => colors != null && data != null && _textStyles != null;

  void setTheme(AppThemeData appThemeData) {
    assert(appThemeData != null);

    var shouldNotifyListeners = initialized;
    _colors = appThemeData.color;
    _data = appThemeData.data;
    _textStyles = appThemeData.textStyles;

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  static void setStatusBarBrightness(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: brightness,
    ));
  }
}
