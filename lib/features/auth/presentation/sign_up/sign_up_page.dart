import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../shared/presentation/personal_info/cubit/personal_info_cubit.dart';
import '../../../../shared/presentation/personal_info/personal_info_form.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../domain/model/sign_up_model.dart';
import '../cubit/sign_up/sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PersonalInfoCubit>(),
      child: Scaffold(
        backgroundColor: AppColorsTheme.scaffold,
        appBar: AppBar(
          title: const Text(
            'Crear Cuenta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColorsTheme.headline,
            ),
          ),
          backgroundColor: AppColorsTheme.surface,
          elevation: 0,
        ),
        body: BlocBuilder<SignUpCubit, ResultState<UserModel>>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColorsTheme.primary,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColorsTheme.headline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Completa la información para crear tu cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColorsTheme.subtitle,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PersonalInfoForm(
                    onCompleteForm: (value) {
                      context.read<SignUpCubit>().setSignUpModel(
                        value as SignUpModel,
                      );
                      context.pushNamed(AppRoutes.signUpAddress);
                    },
                    showPasswordField: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
