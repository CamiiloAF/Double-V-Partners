import 'package:double_v_partners_tech/core/di/injection.dart';
import 'package:double_v_partners_tech/core/presentation/cubit/current_user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'firebase_options.dart';
import 'shared/router/app_router.dart';
import 'shared/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.required: (_) => 'Este campo es requerido',
        ValidationMessage.email: (_) => 'Email inválido',
        ValidationMessage.minLength: (error) =>
            'Debe tener al menos ${(error as Map)['requiredLength']} caracteres',
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<CurrentUserCubit>()),
          BlocProvider(create: (context) => getIt<SignUpCubit>()),
        ],
        child: MaterialApp.router(
          title: 'Double V Partners',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: lightTheme,
          themeMode: ThemeMode.light,
        ),
      ),
    );
  }
}
