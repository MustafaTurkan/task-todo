import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/infrastructure/app_context.dart';
import 'package:todo/infrastructure/logger/logger.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required this.logger, @required this.userRepository, @required this.context})
      : assert(userRepository != null),
        super(AuthenticationInitial());

  final IUserRepository userRepository;
  final Logger logger;
  final AppContext context;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    try {
      final isSignedIn = await userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await userRepository.getUser();
        context.registerAppUser(name);
        yield AuthenticationSuccess(name);
      } else {
        yield AuthenticationFailure();
      }
    } catch (e) {
      logger.error(e.toString());
      yield AuthenticationError(reason: e.toString());
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    try {
      final name = await userRepository.getUser();
      context.registerAppUser(name);
      yield AuthenticationSuccess(name);
    } catch (e) {
      logger.error(e.toString());
      yield AuthenticationError(reason: e.toString());
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    try {
      yield AuthenticationFailure();
      await userRepository.signOut();
    } catch (e) {
      logger.error(e.toString());
      yield AuthenticationError(reason: e.toString());
    }
  }
}
