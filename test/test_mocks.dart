// Este archivo se usa para generar mocks automáticamente
// Ejecuta: dart run build_runner build --delete-conflicting-outputs

// Core
import 'package:double_v_partners_tech/core/firestore/domain/user_collection_repository.dart';
// Auth
import 'package:double_v_partners_tech/features/auth/domain/repositories/login_repository.dart';
import 'package:double_v_partners_tech/features/auth/domain/repositories/sign_up_repository.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/login_with_email_and_password_use_case.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/sign_up_use_case.dart';
// Profile
import 'package:double_v_partners_tech/features/profile/domain/repository/profile_repository.dart';
import 'package:double_v_partners_tech/features/profile/domain/use_case/logout_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  // Firebase
  FirebaseAuth,
  User,
  UserCredential,

  // Auth repositories
  LoginRepository,
  SignUpRepository,

  // Auth use cases
  LoginWithEmailAndPasswordUseCase,
  SignUpUseCase,

  // Profile
  ProfileRepository,
  LogoutUseCase,

  // Core
  UserCollectionRepository,
])
void main() {}
