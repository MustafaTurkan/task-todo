import 'package:todo/infrastructure/l10n/localizer.dart';

enum TodoType { daily, weekly,monthly,other }
enum TodoStatus { waiting, done,}
enum TimeType { hour, day,month,year}



class Enum {
  static String getName(dynamic enumItem) {
    if (enumItem == null) {
      return null;
    }
    return enumItem.toString().split('.').last;
  }

 static String getLocalizationName(dynamic enumItem)
 {
   return Localizer.instance.translate(Enum.getName(enumItem));
 }

}