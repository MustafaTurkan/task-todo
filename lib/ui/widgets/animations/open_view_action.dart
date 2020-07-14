import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/theme/app_theme.dart';

class OpenViewAction extends StatelessWidget {
  const OpenViewAction({this.view, this.onClosed, this.actionText});

  final Widget view;
  final String actionText;
  final Function onClosed;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return view;
      },
      onClosed: (data) {
        if (data != null) {
          onClosed(data);
        }
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Container(
          color: appTheme.colors.primary,
          child: SizedBox(
            height: 36,
            child: Center(
              child: Text(
                actionText,
                style: appTheme.data.textTheme.bodyText1.copyWith(color: appTheme.colors.fontLight),
              ),
            ),
          ),
        );
      },
    );
  }
}
