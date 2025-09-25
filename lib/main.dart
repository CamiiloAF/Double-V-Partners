import 'package:double_v_partners_tech/core/di/injection.dart';
import 'package:double_v_partners_tech/features/auth/presentation/cubit/current_user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'shared/router/app_router.dart';
import 'shared/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CurrentUserCubit>(),
      child: MaterialApp.router(
        title: 'Double V Partners',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
