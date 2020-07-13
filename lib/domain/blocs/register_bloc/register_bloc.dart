import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/domain/validation/login_validation.dart';
import 'package:todo/infrastructure/logger/logger.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    @required IUserRepository userRepository,
    @required Logger logger,
  })  : assert(userRepository != null, logger != null),
        _userRepository = userRepository,
        _logger = logger,
        super(RegisterState.initial());

  IUserRepository _userRepository;
  Logger _logger;

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      // ignore: unnecessary_parenthesis
      return (event is! RegisterEmailChanged && event is! RegisterPasswordChanged);
    });
    final debounceStream = events.where((event) {
      // ignore: unnecessary_parenthesis
      return (event is RegisterEmailChanged || event is RegisterPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: LoginValidator.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: LoginValidator.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      yield RegisterState.success();
    } catch (e) {
      _logger.error(e.toString());
      yield RegisterState.failure();
    }
  }
}
