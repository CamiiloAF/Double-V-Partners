import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/domain/result_state.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import '../../../../shared/widgets/button/custom_button_widget.dart';
import '../../../core/extensions/go_router.dart';
import '../../../core/presentation/cubit/current_user_cubit.dart';
import 'cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _listener(BuildContext context, ResultState<void> state) {
    switch (state) {
      case Data():
        context.read<CurrentUserCubit>().clearCurrentUser();
        context.goAndClearStack(AppRoutes.login);
        break;
      case Error():
        showErrorDialog(context, content: state.error.message);
        break;
      case Loading():
      case Initial():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUserCubit>().state;

    return Scaffold(
      backgroundColor: AppColorsTheme.scaffold,
      appBar: AppBar(
        title: const Text(
          'Perfil',
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
      body: BlocConsumer<ProfileCubit, ResultState<void>>(
        listener: _listener,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, ${currentUser?.firstName ?? 'Usuario'}!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColorsTheme.headline,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gestiona tu información personal y configuraciones',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColorsTheme.subtitle,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: AppColorsTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColorsTheme.primary.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColorsTheme.primary,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Información Personal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColorsTheme.headline,
                          ),
                        ),
                        subtitle: const Text(
                          'Actualiza tu nombre, apellido y fecha de nacimiento',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorsTheme.subtitle,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColorsTheme.subtitle,
                        ),
                        onTap: () {
                          // TODO: Navegar a la pantalla de actualización de información personal
                          // context.pushNamed(AppRoutes.updatePersonalInfo);
                        },
                      ),
                      const Divider(
                        height: 0,
                        color: AppColorsTheme.divider,
                        indent: 16,
                        endIndent: 16,
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColorsTheme.accent.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: AppColorsTheme.accent,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Direcciones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColorsTheme.headline,
                          ),
                        ),
                        subtitle: const Text(
                          'Gestiona tus direcciones guardadas',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorsTheme.subtitle,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColorsTheme.subtitle,
                        ),
                        onTap: () {
                          // TODO: Navegar a la pantalla de gestión de direcciones
                          // context.pushNamed(AppRoutes.manageAddresses);
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButtonWidget(
                  text: 'Cerrar Sesión',
                  onPressed: () => context.read<ProfileCubit>().logout(),
                  isLoading: state is Loading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
