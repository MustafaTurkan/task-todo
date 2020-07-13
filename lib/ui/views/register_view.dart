import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo/domain/blocs/register_bloc/register_bloc.dart';
import 'package:todo/domain/repositories/i_user_repository.dart';
import 'package:todo/infrastructure/l10n/localizer.dart';
import 'package:todo/infrastructure/locator.dart';
import 'package:todo/infrastructure/logger/logger.dart';
import 'package:todo/ui/theme/app_theme.dart';
import 'package:todo/ui/views/base_form_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView()
      : _userRepository = locator.get<IUserRepository>(),
        _logger = locator.get<Logger>();

  final IUserRepository _userRepository;
  final Logger _logger;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    var localizer = Localizer.of(context);
    return BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository, logger: _logger),
        child: BaseFormView(
          haveAppBar: true,
          title: Center(
            child: Text(
              localizer.createAccount,
              style: appTheme.data.textTheme.bodyText1.copyWith(color: appTheme.colors.fontLight, fontSize: 30),
            ),
          ),
          subTitle: Center(
            child: Text(
              localizer.loginSubTitle,
              style: appTheme.data.textTheme.bodyText2.copyWith(color: appTheme.colors.fontLight, fontSize: 18),
            ),
          ),
          child: _RegisterForm(),
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _fnEmail = FocusNode();
  final _fnPassword = FocusNode();

  Localizer _localizer;
  RegisterBloc _registerBloc;
  AppTheme _appTheme;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizer = Localizer.of(context);
    _registerBloc = context.bloc<RegisterBloc>();
    _appTheme = Provider.of<AppTheme>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_localizer.registering),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_appTheme.colors.fontLight),
                    ),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          context.bloc<AuthenticationBloc>().add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_localizer.failRegister),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                    autocorrect: false,
                    autovalidate: true,
                    onFieldSubmitted: (val) {
                      if (state.isEmailValid) {
                        _fnPassword.requestFocus();
                      }
                    },
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
                    autocorrect: false,
                    autovalidate: true,
                    onFieldSubmitted: (val) {
                      if (state.isPasswordValid && isRegisterButtonEnabled(state)) {
                        _onFormSubmitted();
                      }
                    },
                    validator: (_) {
                      return !state.isPasswordValid ? _localizer.passwordInvalid : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: _RegisterButton(
                      onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fnEmail.dispose();
    _fnPassword.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  _RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);
  final VoidCallback _onPressed;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      child: Text(Localizer.of(context).register),
    );
  }
}
