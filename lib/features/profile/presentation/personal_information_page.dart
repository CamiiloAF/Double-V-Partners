import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/domain/result_state.dart';
import '../../../core/domain/user.dart';
import '../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../shared/presentation/personal_info/cubit/personal_info_cubit.dart';
import '../../../shared/presentation/personal_info/personal_info_form.dart';
import '../../../shared/theme/app_colors_theme.dart';
import '../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import 'cubit/update_profile_cubit.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({required this.currentUser, super.key});

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UpdateProfileCubit>()),
        BlocProvider(create: (context) => getIt<PersonalInfoCubit>()),
      ],
      child: BlocListener<UpdateProfileCubit, ResultState<UserModel>>(
        listener: (context, state) {
          if (state is Data) {
            final data = (state as Data<UserModel>).data;

            showSuccessUpdateSnackBar(context);

            context.read<CurrentUserCubit>().setCurrentUser(data);
            return;
          }

          if (state is Error) {
            final error = (state as Error).error.message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar la información: $error'),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColorsTheme.scaffold,
          appBar: AppBar(
            title: const Text(
              'Información Personal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColorsTheme.headline,
              ),
            ),
            backgroundColor: AppColorsTheme.surface,
            elevation: 0,
          ),
          body: SingleChildScrollView(
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
                BlocBuilder<UpdateProfileCubit, ResultState<UserModel>>(
                  builder: (context, state) {
                    return PersonalInfoForm(
                      initialUser: currentUser,
                      isLoading: state is Loading,
                      onCompleteForm: (value) {
                        context
                            .read<UpdateProfileCubit>()
                            .updateUserInformation(
                              value.copyWith(id: currentUser.id),
                            );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
