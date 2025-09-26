part of 'address_cubit.dart';

@freezed
sealed class AddressState with _$AddressState {

  factory AddressState({
    @Default(Initial()) ResultState<LocationData> locationDataResult,
    @Default(<String>[]) List<String> availableDepartments,
    @Default(<AddressFormData>[]) List<AddressFormData> addresses,
  }) = _AddressState;

  AddressState._();

  String countryInputFor(int index) => 'country_$index';

  String departmentInputFor(int index) => 'department_$index';

  String municipalityInputFor(int index) => 'municipality_$index';

  String streetAddressInputFor(int index) => 'streetAddress_$index';

  String complementInputFor(int index) => 'complement_$index';

  String isDefaultInputFor(int index) => 'isDefault_$index';

  // FormGroup dinámico basado en las direcciones actuales
  @override
  late final FormGroup formGroup = _buildDynamicFormGroup();

  FormGroup _buildDynamicFormGroup() {
    final controls = <String, AbstractControl<dynamic>>{};

    for (var i = 0; i < addresses.length; i++) {
      final address = addresses[i];

      controls[countryInputFor(i)] = FormControl<String>(
        value: address.country,
        validators: [Validators.required],
      );
      controls[departmentInputFor(i)] = FormControl<String>(
        value: address.department,
        validators: [Validators.required],
      );
      controls[municipalityInputFor(i)] = FormControl<String>(
        value: address.municipality,
        validators: [Validators.required],
      );
      controls[streetAddressInputFor(i)] = FormControl<String>(
        value: address.streetAddress,
        validators: [Validators.required],
      );
      controls[complementInputFor(i)] = FormControl<String>(
        value: address.complement,
      );
      controls[isDefaultInputFor(i)] = FormControl<bool>(
        value: address.isDefault,
      );
    }

    return FormGroup(controls);
  }

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
    @Default(null) String? department,
    @Default(null) String? municipality,
    @Default('') String streetAddress,
    @Default('') String complement,
    @Default(false) bool isDefault,
    @Default(<String>[]) List<String> availableMunicipalities,
  }) = _AddressFormData;

  const AddressFormData._();

  bool get isComplete {
    return country.isNotEmpty &&
        (department?.isNotEmpty ?? false) &&
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
    if (department?.isNotEmpty ?? false) parts.add(department!);

    return parts.join(', ');
  }

  AddressModel toAddressModel() => AddressModel(
    id: id,
    country: country,
    department: department!,
    municipality: municipality!,
    streetAddress: streetAddress,
    complement: complement,
    isDefault: isDefault,
    createdAt: DateTime.now(),
  );
}
