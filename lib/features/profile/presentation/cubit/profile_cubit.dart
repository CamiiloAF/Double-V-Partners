import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/nothing.dart';
import '../../../../core/domain/result_state.dart';
import '../../domain/use_case/logout_use_case.dart';

@injectable
class ProfileCubit extends Cubit<ResultState<Nothing>> {
  ProfileCubit(this._logoutUseCase) : super(const ResultState.initial());

  final LogoutUseCase _logoutUseCase;

  Future<void> logout() async {
    emit(const ResultState.loading());

    final result = await _logoutUseCase();

    result.fold(
      (error) => emit(ResultState.error(error: error)),
      (data) => emit(ResultState.data(data: data)),
    );
  }
}
