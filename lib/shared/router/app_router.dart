import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain/user.dart';
import '../../features/auth/presentation/login/login_page.dart';
import '../../features/auth/presentation/sign_up/address_form_page.dart';
import '../../features/auth/presentation/sign_up/sign_up_page.dart';
import '../../features/profile/presentation/address_page.dart';
import '../../features/profile/presentation/personal_information_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
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
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: AppRoutes.signUpPersonalInformation,
      name: AppRoutes.signUpPersonalInformation,
      builder: (context, state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: AppRoutes.signUpAddress,
      name: AppRoutes.signUpAddress,
      builder: (context, state) {
        return const SignUpAddressFormPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRoutes.profile,
      builder: (context, state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.profilePersonalInformation,
      name: AppRoutes.profilePersonalInformation,
      builder: (context, state) {
        final currentUser = state.extra as UserModel;
        return PersonalInformationPage(currentUser: currentUser);
      },
    ),
    GoRoute(
      path: AppRoutes.profileAddress,
      name: AppRoutes.profileAddress,
      builder: (context, state) {
        final currentUser = state.extra as UserModel;
        return AddressPage(currentUser: currentUser);
      },
    ),
  ],
);
