import 'package:bloc_test/bloc_test.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/presentation/cubit/current_user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CurrentUserCubit currentUserCubit;

  setUp(() {
    currentUserCubit = CurrentUserCubit();
  });

  tearDown(() {
    currentUserCubit.close();
  });

  group('CurrentUserCubit', () {
    final userModel = UserModel(
      id: 'user123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      birthDate: DateTime(1990),
      createdAt: DateTime.now(),
    );

    test('initial state should be null', () {
      expect(currentUserCubit.state, isNull);
    });

    blocTest<CurrentUserCubit, UserModel?>(
      'should emit user when setCurrentUser is called',
      build: () => currentUserCubit,
      act: (cubit) => cubit.setCurrentUser(userModel),
      expect: () => [userModel],
    );

    blocTest<CurrentUserCubit, UserModel?>(
      'should emit null when setCurrentUser is called with null',
      build: () => currentUserCubit,
      seed: () => userModel,
      act: (cubit) => cubit.clearCurrentUser(),
      expect: () => [null],
    );
  });
}
