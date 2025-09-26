import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../domain/model/user_auth.dart';
import '../../domain/use_cases/login_with_email_and_password_use_case.dart';

@injectable
class LoginCubit extends Cubit<ResultState<UserModel>> {
  LoginCubit({
    required LoginWithEmailAndPasswordUseCase loginWithEmailAndPasswordUseCase,
  }) : _loginWithEmailAndPasswordUseCase = loginWithEmailAndPasswordUseCase,
       super(const ResultState.initial());

  final LoginWithEmailAndPasswordUseCase _loginWithEmailAndPasswordUseCase;

  Future<void> loginWithEmailAndPassword(UserAuthModel userAuth) async {
    emit(const ResultState.loading());
    final result = await _loginWithEmailAndPasswordUseCase(userAuth);

    result.fold(
      (error) => emit(ResultState.error(error: error)),
      (data) => emit(ResultState.data(data: data)),
    );
  }
}
