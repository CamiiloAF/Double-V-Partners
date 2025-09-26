import 'package:bloc/bloc.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:double_v_partners_tech/shared/widgets/forms/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../core/domain/result_state.dart';
import '../../../../../core/domain/user.dart';
import '../../../domain/model/address.dart';

part 'sign_up_cubit.freezed.dart';
part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpUseCase) : super(SignUpState());

  final SignUpUseCase _signUpUseCase;

  Future<void> submitSignUp(List<AddressModel> addresses) async {
    final signUpModel = _buildSignUpModel(addresses);

    final result = await _signUpUseCase(signUpModel);

    result.fold(
      (error) {
        emit(state.copyWith(signUpResult: Error(error: error)));
      },
      (data) {
        emit(state.copyWith(signUpResult: Data(data: data)));
      },
    );
  }

  SignUpModel _buildSignUpModel(List<AddressModel> addresses) {
    return SignUpModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: state.formGroup.getFieldValue<String>(state.firstNameInput),
      lastName: state.formGroup.getFieldValue<String>(state.lastNameInput),
      email: state.formGroup.getFieldValue<String>(state.emailInput),
      birthDate: state.formGroup.getFieldValue<DateTime>(state.birthDateInput),
      createdAt: DateTime.now(),
      password: state.formGroup.getFieldValue<String>(state.passwordInput),
      addresses: addresses,
    );
  }
}
