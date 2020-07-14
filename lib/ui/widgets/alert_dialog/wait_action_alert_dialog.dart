import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/views/todo/update_view.dart';
import 'package:todo/ui/widgets/animations/fade_scale_transaction.dart';
import 'package:todo/ui/widgets/animations/open_view_action.dart';

class WaitActionAlertDialog extends StatelessWidget {
  const WaitActionAlertDialog({Key key, this.onDone, this.onUpdate, this.onDelete, this.todoModel}) : super(key: key);

  final VoidCallback onDone;
  final Function onUpdate;
  final VoidCallback onDelete;
  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    var localizer = Localizer.of(context);
    return FadeScaleTransaction(
      child: AlertDialog(
        title: Text(
         todoModel.title,
          overflow: TextOverflow.ellipsis,
        ),
        content: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: appTheme.colors.success,
                      onPressed: onDone,
                      child: Text(
                        localizer.onDone,
                        style: appTheme.data.textTheme.bodyText1.copyWith(color: appTheme.colors.fontLight),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OpenViewAction(
                      actionText: localizer.update,
                      onClosed:onUpdate,          
                      view: UpdateView(todoModel:todoModel,),
                    )
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: appTheme.colors.error,
                      onPressed: onDelete,
                      child: Text(localizer.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
