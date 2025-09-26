import 'package:bloc/bloc.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/domain/result_state.dart';
import '../../../../../core/domain/user.dart';
import '../../../domain/model/address.dart';

@injectable
class SignUpCubit extends Cubit<ResultState<UserModel>> {
  SignUpCubit(this._signUpUseCase) : super(const Initial());

  final SignUpUseCase _signUpUseCase;

  SignUpModel? _signUpModel;

  void setSignUpModel(SignUpModel model) {
    _signUpModel = model;
  }

  Future<void> submitSignUp(List<AddressModel> addresses) async {
    emit(const Loading());

    final result = await _signUpUseCase(
      _signUpModel!.copyWith(addresses: addresses),
    );

    result.fold(
      (error) {
        emit(Error(error: error));
      },
      (data) {
        emit(Data(data: data));
      },
    );
  }
}
