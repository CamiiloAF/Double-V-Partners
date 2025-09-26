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
    birthDateInput: FormControl<DateTime>(
      validators: [Validators.required, AdultAgeValidator()],
    ),
  });
}

class AdultAgeValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl control) {
    if (control.value == null) return null;

    final birthDate = control.value as DateTime;
    final today = DateTime.now();

    // Calcular la diferencia exacta en días para manejar años bisiestos correctamente
    final daysDifference = today.difference(birthDate).inDays;

    // 18 años = 18 * 365.25 días (considerando años bisiestos)
    // Usamos 6574.5 días que es más preciso: 18 * 365.25 = 6574.5
    const daysIn18Years = 6574;

    if (daysDifference < daysIn18Years) {
      return {'adultAge': 'Debes ser mayor de edad'};
    }

    return null;
  }
}
