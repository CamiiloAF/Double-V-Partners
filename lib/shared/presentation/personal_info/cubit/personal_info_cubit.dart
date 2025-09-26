import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/domain/user.dart';
import '../../../../features/auth/domain/model/sign_up_model.dart';
import '../../../widgets/forms/extensions.dart';

part 'personal_info_cubit.freezed.dart';
part 'personal_info_state.dart';

@injectable
class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(_createInitialState());

  static PersonalInfoState _createInitialState({
    bool showPasswordField = true,
  }) {
    return PersonalInfoState(showPasswordField: showPasswordField);
  }

  void initializeForm({bool showPasswordField = true, UserModel? initialUser}) {
    final newState = PersonalInfoState(showPasswordField: showPasswordField);

    // Si hay datos iniciales, los establecemos
    if (initialUser != null) {
      newState.formGroup.control(newState.firstNameInput).value =
          initialUser.firstName;
      newState.formGroup.control(newState.lastNameInput).value =
          initialUser.lastName;
      newState.formGroup.control(newState.emailInput).value = initialUser.email;
      newState.formGroup.control(newState.birthDateInput).value =
          initialUser.birthDate;
    }

    emit(newState);
  }

  UserModel buildUserModel() {
    final form = state.formGroup;
    return UserModel(
      id: '',
      firstName: form.getFieldValue<String>(state.firstNameInput),
      lastName: form.getFieldValue<String>(state.lastNameInput),
      email: form.getFieldValue<String>(state.emailInput),
      birthDate: form.getFieldValue<DateTime>(state.birthDateInput),
      createdAt: DateTime.now(),
    );
  }

  SignUpModel buildSignUpModel() {
    final user = buildUserModel();
    final password = state.formGroup.getFieldValue<String>(state.passwordInput);

    return SignUpModel.fromUser(user, password);
  }
}
