import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/theme/app_theme.dart';

const double _fabDimension = 56;

class OpenViewWithFloatingActionButton extends StatelessWidget {
  const OpenViewWithFloatingActionButton({Key key, this.view, this.onClosed}) : super(key: key);
  final Widget view;
  final Function onClosed;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return view;
      },
      closedElevation: 6,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_fabDimension / 2),
        ),
      ),
      onClosed: (data) {
        if (data != null) {
          onClosed(data);
        }
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: _fabDimension,
          width: _fabDimension,
          child: Container(
            color: appTheme.colors.primary,
            child: Center(
              child: Icon(
                Icons.add,
                color: appTheme.colors.fontLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
