import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/infrastructure/enums.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/views/base_form_view.dart';

class AddView extends StatefulWidget {
  AddView({Key key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  _AddViewState():_navigator=locator.get<AppNavigator>();
  

  final AppNavigator _navigator;
  final _formKey = GlobalKey<FormState>();
  final _fnTitle = FocusNode();
  final _fnContent = FocusNode();

  TextEditingController _contentController;
  TextEditingController _titleController;
  DateTime _finishDateTime=DateTime.now();
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
  void didChangeDependencies() {
    _appTheme = Provider.of<AppTheme>(context); 
    _localizer = Localizer.of(context);
    super.didChangeDependencies();
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
       child: Container(),
    );
  }
}