import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/theme/app_theme.dart';

class DropDownField<T> extends StatelessWidget {
  DropDownField({
    @required this.items,
    this.selectedItemBuilder,
    this.value,
    @required this.onChanged,
    this.style,
    this.hintText,
    this.itemHeight = kMinInteractiveDimension,
    this.autofocus = false,
    this.isExpanded = true,
  });

  final List<DropdownMenuItem<T>> items;
  final DropdownButtonBuilder selectedItemBuilder;
  final T value;
  final ValueChanged<T> onChanged;
  final TextStyle style;
  final double itemHeight;
  final bool autofocus;
  final String hintText;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return InputDecorator(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8), border: appTheme.data.inputDecorationTheme.enabledBorder),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: isExpanded,
          onChanged: onChanged,
          items: items,
          hint: Text(hintText ?? '', style: appTheme.data.inputDecorationTheme.hintStyle),
        ),
      ),
    );
  }
}
