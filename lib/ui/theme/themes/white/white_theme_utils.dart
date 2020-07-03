import 'package:flutter/material.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/theme_utils.dart';

class WhiteThemeUtils {

  static PreferredSizeWidget  appBarWithLinearGradient(BuildContext context,String title,{bool isShowLeading=true})
  {
    return AppBar(
        leading:isShowLeading?IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ):null,
        centerTitle: true,
        title: Text(
         Localizer.instance.translate(title) ,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: WhiteThemeUtils.linearGradient(),
          ),
        ),
      );
  }


  static LinearGradient linearGradient() {
    return ThemeUtils.linearGradient([
      Color(0xff1a73e9),
      Color(0xff156ada),
      Color(0xff1361c9),
      Color(0xff1259b7),
      Color(0xff1050a4),
    ]);
  }
}
