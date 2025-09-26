import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../core/firestore/domain/use_cases/update_user_use_case.dart';

@injectable
class UpdateProfileCubit extends Cubit<ResultState<UserModel>> {
  UpdateProfileCubit(this._updateUserUseCase)
    : super(const ResultState.initial());

  final UpdateUserUseCase _updateUserUseCase;

  Future<void> updateUserInformation(UserModel userModel) async {
    emit(const ResultState.loading());

    final result = await _updateUserUseCase(userModel);

    result.fold(
      (error) => emit(ResultState.error(error: error)),
      (data) => emit(ResultState.data(data: data)),
    );
  }
}
