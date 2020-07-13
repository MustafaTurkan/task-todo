part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(this.displayName);

  final String displayName;
  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'AuthenticationSuccess { displayName: $displayName }';
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  AuthenticationError({this.reason});
  final String reason;
  @override
  String toString() => 'TodoFail { reason: $reason }';
}
