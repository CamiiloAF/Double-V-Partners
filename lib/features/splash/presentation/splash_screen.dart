import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/firestore/domain/use_cases/get_user_by_id_use_case.dart';
import '../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../shared/router/app_routes.dart';
import '../../../shared/theme/app_colors_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final firebaseAuth = getIt<FirebaseAuth>();
    final currentFirebaseUser = firebaseAuth.currentUser;

    if (!mounted) return;

    if (currentFirebaseUser != null) {
      await _loadCurrentUser(currentFirebaseUser.uid);
    } else {
      _navigateToLogin();
    }
  }

  Future<void> _loadCurrentUser(String userId) async {
    try {
      final getUserUseCase = getIt<GetUserByIdUseCase>();
      final result = await getUserUseCase(userId);

      if (!mounted) return;

      result.fold(
        (error) {
          _navigateToLogin();
        },
        (user) {
          context.read<CurrentUserCubit>().setCurrentUser(user);
          _navigateToProfile();
        },
      );
    } catch (e) {
      if (!mounted) return;
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      context.pushReplacementNamed(AppRoutes.login);
    }
  }

  void _navigateToProfile() {
    if (mounted) {
      context.pushReplacementNamed(AppRoutes.profile);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.primary,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          size: 60,
                          color: AppColorsTheme.primary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Double V Partners',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Gestión de usuarios',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),

                      const SizedBox(height: 60),

                      const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Cargando...',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
