part of 'personal_info_cubit.dart';

@freezed
sealed class PersonalInfoState with _$PersonalInfoState {
  factory PersonalInfoState({@Default(false) bool showPasswordField}) =
      _PersonalInfoState;

  PersonalInfoState._();

  String get firstNameInput => 'firstName';

  String get lastNameInput => 'lastName';

  String get emailInput => 'email';

  String get passwordInput => 'password';

  String get birthDateInput => 'birthDate';

  @override
  late final FormGroup formGroup = FormGroup({
    firstNameInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(2)],
    ),
    lastNameInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(2)],
    ),
    emailInput: FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    if (showPasswordField)
      passwordInput: FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
    birthDateInput: FormControl<DateTime>(validators: [Validators.required]),
  });
}
