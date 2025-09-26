part of 'sign_up_cubit.dart';

@freezed
sealed class SignUpState with _$SignUpState {
  SignUpState._();

  factory SignUpState({
    @Default(Initial()) ResultState<UserModel> signUpResult,
  }) = _SignUpState;

  String get idInput => 'id';

  String get firstNameInput => 'firstName';

  String get lastNameInput => 'lastName';

  String get emailInput => 'email';

  String get passwordInput => 'password';

  String get birthDateInput => 'birthDate';

  String get addressInput => 'addresses';

  @override
  late final FormGroup formGroup = FormGroup({
    idInput: FormControl<String?>(),
    firstNameInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(3)],
    ),
    lastNameInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(3)],
    ),
    emailInput: FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    passwordInput: FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    birthDateInput: FormControl<DateTime>(validators: [Validators.required]),
    addressInput: FormControl<List<AddressModel>>(),
  });

  bool get isValidForm => formGroup.valid;
}
