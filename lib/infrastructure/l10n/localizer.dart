import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/infrastructure/app_string.dart';
import 'locales/messages_all.dart';

class Localizer {
  // workaroud for contextless translation
  //see https://github.com/flutter/flutter/issues/14518#issuecomment-447481671
  static Localizer instance;

  static Future<Localizer> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = Localizer();
      return instance;
    });
  }

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  String get appName => Intl.message(AppString.appName);
  String get daily => Intl.message(AppString.daily);
  String get weekly => Intl.message(AppString.weekly);
  String get monthly => Intl.message(AppString.monthly);

  String get waiting => Intl.message(AppString.waiting);
  String get done => Intl.message(AppString.done);
  String get notDone => Intl.message(AppString.notDone);
  String get title => Intl.message(AppString.title);
  String get content => Intl.message(AppString.content);
  String get cancel => Intl.message(AppString.cancel);
  String get add => Intl.message(AppString.add);
  String get period => Intl.message(AppString.period);
  String get newTask => Intl.message(AppString.newTask);
  String get error => Intl.message(AppString.error);
  String get requiredValue => Intl.message(AppString.requiredValue);
  String get onDone => Intl.message(AppString.onDone);
  String get detail => Intl.message(AppString.detail);
  String get delete => Intl.message(AppString.delete);
  String get onWaiting => Intl.message(AppString.onWaiting);
  String get emptyMessage => Intl.message(AppString.emptyMessage);
  String get update => Intl.message(AppString.update);
  String get task => Intl.message(AppString.task);
  String get hour => Intl.message(AppString.hour);
  String get day => Intl.message(AppString.day);
  String get time => Intl.message(AppString.time);
  String get up => Intl.message(AppString.up);
  String get failLogin=>Intl.message(AppString.failLogin);
  String get loginTitle=>Intl.message(AppString.loginTitle);
  String get loginSubTitle=>Intl.message(AppString.loginSubTitle);
  String get loginIn=>Intl.message(AppString.loginIn);
  String get email=>Intl.message(AppString.email);
  String get emailInvalid=>Intl.message(AppString.emailInvalid);
  String get password=>Intl.message(AppString.password);
  String get passwordInvalid=>Intl.message(AppString.passwordInvalid);
  String get createAccount=>Intl.message(AppString.createAccount);
  String get login=>Intl.message(AppString.login);
  String get loginWithGoogle=>Intl.message(AppString.loginWithGoogle);
  String get registering =>Intl.message(AppString.registering);
  String get failRegister =>Intl.message(AppString.failRegister);
  String get register =>Intl.message(AppString.register);
  String get other =>Intl.message(AppString.other);
  String get updateTask =>Intl.message(AppString.updateTask);
  
  
  //dynamic text translate
  String translate(String text,
      {String desc = '',
      Map<String, Object> examples = const {},
      String locale,
      String name,
      List<Object> args,
      String meaning,
      bool skip}) {
    return Intl.message(text,
        desc: desc, examples: examples, locale: locale, name: name, args: args, meaning: meaning, skip: skip);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localizer> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return Localizer.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localizer> old) {
    return false;
  }
}
