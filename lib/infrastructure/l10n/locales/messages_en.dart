// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: unnecessary_brace_in_string_interps,annotate_overrides,always_declare_return_types,implicit_dynamic_return,invalid_assignment,map_value_type_not_assignable,implicit_dynamic_parameter

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:todo/infrastructure/app_string.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args); 
class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        AppString.appName: MessageLookupByLibrary.simpleMessage('Tasks'),
        AppString.unExpectedErrorOccurred: MessageLookupByLibrary.simpleMessage('An unexpected error occurred !'),
        AppString.daily: MessageLookupByLibrary.simpleMessage('Daily'),
        AppString.weekly: MessageLookupByLibrary.simpleMessage('Weekly'),
        AppString.monthly: MessageLookupByLibrary.simpleMessage('Monthly'),
        AppString.waiting: MessageLookupByLibrary.simpleMessage('Waiting'),
        AppString.done: MessageLookupByLibrary.simpleMessage('Completed'),
        AppString.notDone: MessageLookupByLibrary.simpleMessage('Unexecuted'),
        AppString.title: MessageLookupByLibrary.simpleMessage('Title'),
        AppString.content: MessageLookupByLibrary.simpleMessage('Content'),
        AppString.cancel: MessageLookupByLibrary.simpleMessage('Cancel'),
        AppString.add: MessageLookupByLibrary.simpleMessage('Add'),
        AppString.period: MessageLookupByLibrary.simpleMessage('Period'),
        AppString.newTask: MessageLookupByLibrary.simpleMessage('New Task'),
        AppString.error: MessageLookupByLibrary.simpleMessage('Error'),
        AppString.requiredValue: MessageLookupByLibrary.simpleMessage('Value cannot be empty'),
        AppString.onDone: MessageLookupByLibrary.simpleMessage('Completed'),
        AppString.delete: MessageLookupByLibrary.simpleMessage('Delete'),
        AppString.detail: MessageLookupByLibrary.simpleMessage('Detail'),
        AppString.update: MessageLookupByLibrary.simpleMessage('Update'),
        AppString.onWaiting: MessageLookupByLibrary.simpleMessage('Send on hold'),
        AppString.emptyMessage: MessageLookupByLibrary.simpleMessage('You have no notes. You may want to add:)'),
        AppString.task: MessageLookupByLibrary.simpleMessage('Task'),
        AppString.hour: MessageLookupByLibrary.simpleMessage('Hour'),
        AppString.day: MessageLookupByLibrary.simpleMessage('Day'),
        AppString.time: MessageLookupByLibrary.simpleMessage('Time'),
        AppString.up: MessageLookupByLibrary.simpleMessage('Up'),
        AppString.failLogin: MessageLookupByLibrary.simpleMessage('Login Failure'),
        AppString.loginTitle: MessageLookupByLibrary.simpleMessage('Login'),
        AppString.loginSubTitle: MessageLookupByLibrary.simpleMessage('Welcome'),
        AppString.loginIn: MessageLookupByLibrary.simpleMessage('Login In...'),
       AppString.email: MessageLookupByLibrary.simpleMessage('Email'),
 AppString.emailInvalid: MessageLookupByLibrary.simpleMessage('Invalid Email'),
 AppString.password: MessageLookupByLibrary.simpleMessage('Password'),
AppString.passwordInvalid: MessageLookupByLibrary.simpleMessage('Invalid Password'),
  AppString.login: MessageLookupByLibrary.simpleMessage('Login'),
AppString.loginWithGoogle: MessageLookupByLibrary.simpleMessage('Sign in with Google'),   
AppString.createAccount: MessageLookupByLibrary.simpleMessage('Create an Account'),   
        AppString.registering: MessageLookupByLibrary.simpleMessage('Registering...'), 
               AppString.failRegister: MessageLookupByLibrary.simpleMessage('Registration Failure'),
                  AppString.register: MessageLookupByLibrary.simpleMessage('Register'),
                     AppString.other: MessageLookupByLibrary.simpleMessage('Other'),
        
      };
}
