import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateTimeFormField extends StatefulWidget {
  const DateTimeFormField({Key key,this.onChange}) : super(key: key);
  final Function onChange;
  @override
  _DateTimeFormFieldState createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends State<DateTimeFormField> {
  final format = DateFormat('dd-MM-yyyy HH:mm');
  final initialValue = DateTime.now().add(Duration(hours:1));

  @override
  Widget build(BuildContext context) {
 
    return  Column(children: <Widget>[
      DateTimeField(
        
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate:  DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },

     onChanged: (date)
     {
       widget.onChange(date??initialValue);
     }, 
  
        initialValue: initialValue,

      ),

    ]);
  }
}