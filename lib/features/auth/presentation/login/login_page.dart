import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import '../../../../shared/widgets/button/custom_button_widget.dart';
import '../../../../shared/widgets/forms/custom_form.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../../domain/model/user_auth.dart';
import '../cubit/login_cubit.dart';
import '../sign_up/widgets/section_container.dart';
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
  bool _obscurePassword = true;

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

    await context.read<LoginCubit>().loginWithEmailAndPassword(userAuth);
  }

  void _listener(BuildContext context, ResultState<UserModel> state) {
    switch (state) {
      case Data():
        context.read<CurrentUserCubit>().setCurrentUser(state.data);
        FocusScope.of(context).unfocus();
        context.pushReplacementNamed(AppRoutes.profile);
        break;
      case Error():
        showErrorDialog(context, content: state.error.message);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.scaffold,
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColorsTheme.headline,
          ),
        ),
        backgroundColor: AppColorsTheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: ReactiveFormConfig(
        validationMessages: {
          ValidationMessage.required: (_) => LoginStrings.requiredField,
          ValidationMessage.email: (_) => LoginStrings.invalidEmail,
          ValidationMessage.minLength: (data) => LoginStrings.minLengthError(
            (data as Map<String, dynamic>)['requiredLength'].toString(),
          ),
        },
        child: BlocConsumer<LoginCubit, ResultState<UserModel>>(
          listener: _listener,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: CustomForm(
                formGroup: formGroup,
                fields: [
                  // Header de bienvenida con el mismo estilo del sign up
                  const Text(
                    '¡Bienvenido de vuelta!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColorsTheme.headline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa tus credenciales para acceder',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColorsTheme.subtitle,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sección de formulario con el mismo contenedor del sign up
                  _buildLoginSection(),
                  const SizedBox(height: 40),

                  // Botón de login
                  ReactiveFormConsumer(
                    builder: (_, form, child) {
                      return CustomButtonWidget(
                        text: LoginStrings.loginButton,
                        onPressed: form.valid ? () => doLogin(form) : null,
                        isLoading: state is Loading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Link para registro
                  Center(
                    child: TextButton(
                      onPressed: () => context.pushNamed(
                        AppRoutes.signUpPersonalInformation,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorsTheme.subtitle,
                          ),
                          children: [
                            TextSpan(text: '¿No tienes cuenta? '),
                            TextSpan(
                              text: 'Regístrate',
                              style: TextStyle(
                                color: AppColorsTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return FormSectionContainer(
      title: 'Credenciales de Acceso',
      icon: Icons.login_outlined,
      children: [
        const CustomTextField(
          formControlName: _emailInput,
          labelText: LoginStrings.email,
          hintText: 'ejemplo@correo.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          formControlName: _passwordInput,
          labelText: LoginStrings.password,
          hintText: 'Ingresa tu contraseña',
          obscureText: _obscurePassword,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColorsTheme.subtitle,
          ),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColorsTheme.subtitle,
            ),
          ),
        ),
      ],
    );
  }
}
