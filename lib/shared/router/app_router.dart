import 'package:double_v_partners_tech/features/auth/presentation/addresses/address_form_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/addresses/params.dart';
import '../../features/auth/presentation/login/login_page.dart';
import '../../features/auth/presentation/sign_up/sign_up_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final isLoggingIn = state.matchedLocation == AppRoutes.login;
    final isSigningUp =
        state.matchedLocation == AppRoutes.signUpPersonalInformation ||
        state.matchedLocation == AppRoutes.signUpAddress;

    if (isLoggedIn && (isLoggingIn || isSigningUp)) {
      return AppRoutes.profile;
    }

    if (!isLoggedIn && state.matchedLocation == AppRoutes.profile) {
      return AppRoutes.login;
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: AppRoutes.signUpPersonalInformation,
      name: AppRoutes.signUpPersonalInformation,
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: AppRoutes.signUpAddress,
      name: AppRoutes.signUpAddress,
      builder: (BuildContext context, GoRouterState state) {
        final params = state.extra as AddressPageParams;
        return AddressFormPage(params: params);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profile,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
  ],
);
