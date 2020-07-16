import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/views/shared/base_form_view.dart';
import 'package:todo/ui/widgets/date_time_form_filed.dart';
import 'package:todo/ui/widgets/drop_down_field.dart';
import 'package:todo/ui/widgets/from_field_padding.dart';

class AddView extends StatefulWidget {
  AddView({Key key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  _AddViewState() : _navigator = locator.get<AppNavigator>();

  final AppNavigator _navigator;
  final _formKey = GlobalKey<FormState>();
  final _fnTitle = FocusNode();
  final _fnContent = FocusNode();

  TextEditingController _contentController;
  TextEditingController _titleController;
  DateTime _finishDateTime = DateTime.now();
  AppTheme _appTheme;
  Localizer _localizer;
  TodoType _type;


  @override
  void initState() {
      super.initState();
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _type = TodoType.daily;
  
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appTheme = Provider.of<AppTheme>(context);
    _localizer = Localizer.of(context);
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
  Widget build(BuildContext context) {
    return BaseFormView(
      height: 5,
      haveAppBar: true,
      title: Center(
        child: Text(
          _localizer.newTask,
          style: _appTheme.data.textTheme.bodyText1.copyWith(color: _appTheme.colors.fontLight, fontSize: 30),
        ),
      ),
      subTitle: Center(
        child: Text(
          _localizer.add,
          style: _appTheme.data.textTheme.bodyText2.copyWith(color: _appTheme.colors.fontLight, fontSize: 18),
        ),
      ),
      child: _buildAddForm(),
    );
  }

  Widget _buildAddForm() {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),   
            FormFieldPadding(
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
            if (_type == TodoType.other)
              FormFieldPadding(
                child: DateTimeFormField(
                  onChange: (date) {
                    _finishDateTime = date;
                  },
                ),
              ),
            FormFieldPadding(
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
            FormFieldPadding(
              child: TextFormField(
                  focusNode: _fnContent,
                  controller: _contentController,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(150),
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
            FormFieldPadding(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: FlatButton(
                  color: _appTheme.data.primaryColor,
                  onPressed: _onFormSubmit,
                  child: Text(
                    _localizer.add,
                    style: _appTheme.data.textTheme.subtitle1.copyWith(color: _appTheme.colors.fontLight),
                  ),
                ))
              ],
            ))
          ],
        ));
  }

  void _onFormSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    var todo = TodoModel(
        period: _type.index,
        finishedDate: _finishDateTime,
        title: _titleController.text,
        text: _contentController.text,
        status: TodoStatus.waiting.index);
    _navigator.pop(context,result:todo);
  }
}
