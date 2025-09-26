part of 'address_cubit.dart';

@freezed
sealed class AddressState with _$AddressState {
  AddressState._();

  factory AddressState({
    @Default(Initial()) ResultState<LocationData> locationDataResult,
    @Default(<String>[]) List<String> availableDepartments,
    @Default(<AddressFormData>[]) List<AddressFormData> addresses,
  }) = _AddressState;

  // Form inputs
  String get countryInput => 'country';

  String get departmentInput => 'department';

  String get municipalityInput => 'municipality';

  String get streetAddressInput => 'streetAddress';

  String get complementInput => 'complement';

  String get isDefaultInput => 'isDefault';

  @override
  late final FormGroup formGroup = FormGroup({
    countryInput: FormControl<String>(validators: [Validators.required]),
    departmentInput: FormControl<String>(validators: [Validators.required]),
    municipalityInput: FormControl<String>(validators: [Validators.required]),
    streetAddressInput: FormControl<String>(validators: [Validators.required]),
    complementInput: FormControl<String>(),
    isDefaultInput: FormControl<bool>(value: false),
  });

  int get addressCount => addresses.length;

  bool get isLoadingLocations => locationDataResult is Loading;

  LocationData? get locationData => locationDataResult is Data
      ? (locationDataResult as Data<LocationData>).data
      : null;
}

@freezed
sealed class AddressFormData with _$AddressFormData {
  const factory AddressFormData({
    required String id,
    @Default('Colombia') String country,
    @Default('') String department,
    @Default(null) String? municipality,
    @Default('') String streetAddress,
    @Default('') String complement,
    @Default(false) bool isDefault,
    @Default(<String>[]) List<String> availableMunicipalities,
  }) = _AddressFormData;

  const AddressFormData._();

  bool get isComplete {
    return country.isNotEmpty &&
        department.isNotEmpty &&
        (municipality?.isNotEmpty ?? false) &&
        streetAddress.isNotEmpty;
  }

  String get displayName {
    if (streetAddress.isEmpty) return 'Nueva dirección';

    final parts = <String>[];
    if (streetAddress.isNotEmpty) parts.add(streetAddress);
    if (municipality != null && municipality!.isNotEmpty) {
      parts.add(municipality!);
    }
    if (department.isNotEmpty) parts.add(department);

    return parts.join(', ');
  }

  AddressModel toAddressModel() => AddressModel(
    id: id,
    country: country,
    department: department,
    municipality: municipality!,
    streetAddress: streetAddress,
    complement: complement,
    isDefault: isDefault,
    createdAt: DateTime.now(),
  );
}
