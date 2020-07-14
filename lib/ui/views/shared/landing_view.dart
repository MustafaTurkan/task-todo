import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo/domain/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo/domain/repositories/i_todo_repository.dart';
import 'package:todo/infrastructure/error/error_localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/views/shared/error_view.dart';
import 'package:todo/ui/views/shared/home_view.dart';
import 'package:todo/ui/views/login/login_view.dart';
import 'package:todo/ui/widgets/waiting_view.dart';

class LandingView extends StatelessWidget {
  LandingView()
      : _logger = locator.get<Logger>(),
        _todoRepository = locator.get<ITodoRepository>();
  final Logger _logger;
  final ITodoRepository _todoRepository;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      if (state is AuthenticationSuccess) {
        return BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(logger: _logger, repository: _todoRepository, userId: state.displayName),
          child: HomeView(),
        );
      }
      if (state is AuthenticationFailure) {
        return LoginView();
      } else if (state is AuthenticationError) {
        return ErrorView(errorText: ErrorLocalizer.translate(state.reason));
      } else {
        return WaitingView();
      }
    });
  }
}
