import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/ui/theme/app_theme.dart';

class WaitActionAlertDialog extends StatelessWidget {
  const WaitActionAlertDialog({Key key,this.title, this.onDone, this.onUpdate, this.onDelete}) : super(key: key);
  
  final String title;
  final VoidCallback onDone;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;


  @override
  Widget build(BuildContext context) {
    var appTheme=Provider.of<AppTheme>(context);
    var localizer = Localizer.of(context);
    return  AlertDialog(
             title:Text(title,overflow:TextOverflow.ellipsis,),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color:appTheme.colors.success,
                          onPressed:onDone,
                          child: Text(localizer.onDone,style: appTheme.data.textTheme.bodyText1.copyWith(color:appTheme.colors.fontLight),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed:onUpdate,
                          child: Text(localizer.update),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: appTheme.colors.error,
                          onPressed:onDelete,
                          child: Text(localizer.delete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}