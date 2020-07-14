import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo/domain/blocs/login_bloc/login_bloc.dart';
import 'package:todo/domain/blocs/login_bloc/login_event.dart';
import 'package:todo/domain/blocs/login_bloc/login_state.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/app_navigator.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/views/shared/base_form_view.dart';

class LoginView extends StatelessWidget {
  LoginView()
      : _userRepository = locator.get<IUserRepository>(),
        _logger = locator.get<Logger>();

  final IUserRepository _userRepository;
  final Logger _logger;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    var localizer = Localizer.of(context);
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(userRepository: _userRepository, logger: _logger),
      child: BaseFormView(
        title: Center(
          child: Text(
            localizer.loginTitle,
            style: appTheme.data.textTheme.bodyText1.copyWith(color: appTheme.colors.fontLight, fontSize: 30),
          ),
        ),
        subTitle: Center(
          child: Text(
            localizer.loginSubTitle,
            style: appTheme.data.textTheme.bodyText2.copyWith(color: appTheme.colors.fontLight, fontSize: 18),
          ),
        ),
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  _LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();

  LoginBloc _loginBloc;
  Localizer _localizer;
  AppTheme _appTheme;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginBloc = context.bloc<LoginBloc>();
    _localizer = Localizer.of(context);
    _appTheme = Provider.of<AppTheme>(context);
  }

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(_localizer.failLogin), Icon(Icons.error)],
                  ),
                  backgroundColor: _appTheme.colors.error,
                ),
              );
          }
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_localizer.loginIn),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_appTheme.colors.fontLight),
                      )
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            context.bloc<AuthenticationBloc>().add(AuthenticationLoggedIn());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      focusNode: _fnEmail,
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: _localizer.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        if (state.isEmailValid) {
                          _fnPassword.requestFocus();
                        }
                      },
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isEmailValid ? _localizer.emailInvalid : null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _fnPassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: _localizer.password,
                      ),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      onFieldSubmitted: (val) {
                        if (state.isPasswordValid && isLoginButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                      },
                      validator: (_) {
                        return !state.isPasswordValid ? _localizer.passwordInvalid : null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _LoginButton(
                            onPressed: isLoginButtonEnabled(state) ? _onFormSubmitted : null,
                          ),
                          _GoogleLoginButton(),
                          _CreateAccountButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fnPassword.dispose();
    _fnEmail.dispose();
    super.dispose();
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  _LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      child: Text(Localizer.of(context).login),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () {
        context.bloc<LoginBloc>().add(
              LoginWithGooglePressed(),
            );
      },
      label: Text(Localizer.of(context).loginWithGoogle, style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appNavigator = locator.get<AppNavigator>();
    return FlatButton(
      onPressed: () {
        appNavigator.pushRegister(context);
      },
      child: Text(
        Localizer.of(context).createAccount,
      ),
    );
  }
}
