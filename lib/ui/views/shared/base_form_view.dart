import 'package:flutter/material.dart';
import 'package:todo/ui/theme/themes/white/white_theme_utils.dart';

class BaseFormView extends StatelessWidget {
  const BaseFormView({Key key, this.title, this.subTitle, this.child,this.haveAppBar=false,this.height=80}) : super(key: key);
   
  final Widget title;
  final Widget subTitle;
  final Widget child; 
  final bool haveAppBar;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar:haveAppBar?AppBar(
          elevation:0,
          backgroundColor:Color(0xff1a73e9),
        ):null,
        body:Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: WhiteThemeUtils.linearGradient()),
            child: Column(
              children: <Widget>[
                SizedBox(height: height),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                     title,
                      SizedBox(height: 10),
                     subTitle
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: child))
              ],
            ),
          )
      ),
    );
  }
}

