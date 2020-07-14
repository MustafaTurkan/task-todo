import 'package:flutter/material.dart';
import 'package:todo/ui/theme/themes/white/white_theme_utils.dart';

class BaseFormView extends StatelessWidget {
  const BaseFormView({Key key, this.title, this.subTitle, this.child,this.haveAppBar=false}) : super(key: key);
   
  final Widget title;
  final Widget subTitle;
  final Widget child; 
  final bool haveAppBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,   
        appBar:haveAppBar?AppBar(
          elevation:0,
          backgroundColor:Color(0xff1a73e9),
        ):null,
        body:Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: WhiteThemeUtils.linearGradient()),
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                Padding(
                  padding: EdgeInsets.all(20),
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
                    child: ClipPath(
                        clipper: _WavePathClipper(),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: child)))
              ],
            ),
          )
      ),
    );
  }
}

class _WavePathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //minimum required size dan küçük ise(keyboard açık ise) kırpma
    if (size.height < 100) {
      return null;
    }
    var path = Path();
    path.lineTo(0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

