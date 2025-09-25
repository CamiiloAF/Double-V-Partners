import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/di/injection.dart';
import '../../../core/domain/result_state.dart';
import '../../../shared/router/app_routes.dart';
import '../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import '../../../shared/widgets/button/custom_button_widget.dart';
import '../../../shared/widgets/forms/custom_form.dart';
import '../../../shared/widgets/inputs/custom_text_field.dart';
import '../domain/model/user.dart';
import '../domain/model/user_auth.dart';
import 'cubit/current_user_cubit.dart';
import 'cubit/login_cubit.dart';
import 'strings.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const _emailInput = 'email';
  static const _passwordInput = 'password';

  final formGroup = FormGroup({
    _emailInput: FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    _passwordInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
  });

  Future<void> doLogin(FormGroup form) async {
    final email = form.value[_emailInput].toString();
    final password = form.value[_passwordInput].toString();

    final userAuth = UserAuthModel(email: email, password: password);

    context.read<LoginCubit>().loginWithEmailAndPassword(userAuth);
  }

  void _listener(BuildContext context, ResultState<UserModel> state) {
    switch (state) {
      case Data():
        context.read<CurrentUserCubit>().setCurrentUser(state.data);
        context.pushReplacementNamed(AppRoutes.profile);
        break;
      case Error():
        showErrorDialog(context, content: state.error.message);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LoginStrings.welcome, style: theme.textTheme.displaySmall),
            const SizedBox(height: 20),
            Text(LoginStrings.login, style: theme.textTheme.headlineMedium),
            ReactiveFormConfig(
              validationMessages: {
                ValidationMessage.required: (_) => LoginStrings.requiredField,
                ValidationMessage.email: (_) => LoginStrings.invalidEmail,
                ValidationMessage.minLength: (data) =>
                    LoginStrings.minLengthError(
                      (data as Map<String, dynamic>)['requiredLength']
                          .toString(),
                    ),
              },
              child: BlocConsumer<LoginCubit, ResultState<UserModel>>(
                listener: _listener,
                builder: (context, state) {
                  return CustomForm(
                    formGroup: formGroup,
                    fields: [
                      CustomTextField(
                        formControlName: _emailInput,
                        label: LoginStrings.email,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        formControlName: _passwordInput,
                        label: LoginStrings.password,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      ReactiveFormConsumer(
                        builder: (_, form, child) {
                          return CustomButtonWidget(
                            text: LoginStrings.loginButton,
                            enabled: form.valid,
                            onPressed: form.valid ? () => doLogin(form) : null,
                            isLoading: state is Loading,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
