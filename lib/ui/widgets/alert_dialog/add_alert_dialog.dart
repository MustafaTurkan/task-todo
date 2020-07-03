import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/widgets/drop_down_field.dart';
import 'package:todo/ui/widgets/from_field_padding.dart';

class AddAlertDialog extends StatefulWidget {
  AddAlertDialog({Key key, this.onAdd, this.onCancel}) : super(key: key);
  final Function(TodoModel) onAdd;
  final VoidCallback onCancel;

  @override
  _AddAlertDialogState createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fnTitle = FocusNode();
  final _fnContent = FocusNode();

  TextEditingController _contentController;
  TextEditingController _titleController;
  AppTheme _appTheme;
  Localizer _localizer;
  TodoType _type;

  @override
  void initState() {
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _type = TodoType.daily;
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _fnTitle.dispose();
    _fnContent.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _appTheme = Provider.of<AppTheme>(context);
    _localizer = Localizer.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_localizer.newTask),
      content: Container(
        height: 240,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: FormFieldPadding(
                    child: DropDownField<String>(
                        hintText: _localizer.period,
                        value: Enum.getLocalizationName(_type),
                        items: TodoType.values.map((value) {
                          return DropdownMenuItem(
                            value: Enum.getLocalizationName(value),
                            child: Text(Enum.getLocalizationName(value)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _type = TodoType.values.firstWhere((e) => Enum.getLocalizationName(e) == val);
                          });
                        })),
              ),
              Expanded(
                child: FormFieldPadding(
                  child: TextFormField(
                    focusNode: _fnTitle,
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return _localizer.requiredValue;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: _localizer.title),
                    onFieldSubmitted: (val) {
                      _fnContent.requestFocus();
                    },
                  ),
                ),
              ),
              Expanded(
                child: FormFieldPadding(
                  child: TextFormField(
                      focusNode: _fnContent,
                      controller: _contentController,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return _localizer.requiredValue;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: _localizer.content,
                      ),
                      onFieldSubmitted: (val) {
                        _onFormSubmit();
                      }),
                ),
              ),
              Expanded(
                child: FormFieldPadding(
                    child: Row(
                  children: <Widget>[
                    Expanded(child: Builder(builder: (context) {
                      return FlatButton(
                        color: _appTheme.data.errorColor,
                        onPressed: widget.onCancel,
                        child: Text(
                          _localizer.cancel,
                          style: _appTheme.data.textTheme.subtitle1.copyWith(color: _appTheme.colors.fontLight),
                        ),
                      );
                    })),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Builder(builder: (context) {
                      return FlatButton(
                        color: _appTheme.data.primaryColor,
                        onPressed: _onFormSubmit,
                        child: Text(
                          _localizer.add,
                          style: _appTheme.data.textTheme.subtitle1.copyWith(color: _appTheme.colors.fontLight),
                        ),
                      );
                    }))
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    var todo = TodoModel(
        period: _type.index,
        title: _titleController.text,
        text: _contentController.text,
        status: TodoStatus.waiting.index);
    widget.onAdd(todo);
  }
}
