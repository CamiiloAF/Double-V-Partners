import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/services/location_service.dart';
import '../../../../features/auth/domain/model/address.dart';

part 'address_cubit.freezed.dart';
part 'address_state.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  AddressCubit(this._locationService) : super(AddressState()) {
    _loadLocationData();
  }

  final LocationService _locationService;

  // MARK: - Initialization
  Future<void> _loadLocationData() async {
    emit(state.copyWith(locationDataResult: const ResultState.loading()));

    try {
      final locationData = await _locationService.loadColombiaData();
      final departments = _locationService.getDepartmentNames(locationData);

      emit(state.copyWith(
        locationDataResult: ResultState.data(data: locationData),
        availableDepartments: departments,
      ));
    } catch (e) {
      emit(state.copyWith(
        locationDataResult: ResultState.error(
          error: DomainException(message: 'Error cargando la información.'),
        ),
      ));
    }
  }

  // MARK: - Address Management
  void addNewAddress() {
    final newAddress = AddressFormData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    final updatedAddresses = [...state.addresses, newAddress];
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void removeAddress(int index) {
    if (!_canRemoveAddress()) return;

    final updatedAddresses = _copyAddressList();
    updatedAddresses.removeAt(index);

    _ensureDefaultAddressExists(updatedAddresses);
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void loadExistingAddresses(List<AddressModel> addresses) {
    final formDataList = addresses.map(_mapToFormData).toList();
    emit(state.copyWith(addresses: formDataList));
  }

  void resetForm() {
    final defaultAddress = AddressFormData(
      id: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
    );
    emit(state.copyWith(addresses: [defaultAddress]));
  }

  // MARK: - Field Updates
  void onChangeCountry(int index, String country) {
    _updateAddressAtIndex(
        index, (address) => address.copyWith(country: country));
  }

  void onChangeDepartment(int index, String department) {
    _updateAddressAtIndex(index, (address) {
      var updatedAddress = address.copyWith(
        department: department,
        municipality: null,
        availableMunicipalities: [],
      );

      final municipalities = _getMunicipalitiesForDepartment(department);
      return updatedAddress.copyWith(availableMunicipalities: municipalities);
    });
  }

  void onChangeMunicipality(int index, String municipality) {
    _updateAddressAtIndex(index, (address) =>
        address.copyWith(municipality: municipality));
  }

  void onChangeStreetAddress(int index, String streetAddress) {
    _updateAddressAtIndex(index, (address) =>
        address.copyWith(streetAddress: streetAddress));
  }

  void onChangeComplement(int index, String complement) {
    _updateAddressAtIndex(index, (address) =>
        address.copyWith(complement: complement));
  }

  void onChangeDefaultAddress(int index, {required bool value}) {
    if (!_isValidIndex(index)) return;

    final updatedAddresses = _copyAddressList();

    if (value) {
      _clearAllDefaultFlags(updatedAddresses, exceptIndex: index);
    }

    updatedAddresses[index] =
        updatedAddresses[index].copyWith(isDefault: value);
    emit(state.copyWith(addresses: updatedAddresses));
  }

  // MARK: - Validation
  String? validateAddresses() {
    if (state.addresses.isEmpty) {
      return 'Debes agregar al menos una dirección';
    }

    if (!_hasDefaultAddress()) {
      return 'Debes marcar al menos una dirección como principal';
    }

    return _validateAllAddresses();
  }

  // MARK: - Private Helper Methods
  bool _isValidIndex(int index) =>
      index >= 0 && index < state.addresses.length;

  bool _canRemoveAddress() => state.addresses.length > 1;

  bool _hasDefaultAddress() =>
      state.addresses.any((address) => address.isDefault);

  List<AddressFormData> _copyAddressList() =>
      List<AddressFormData>.from(state.addresses);

  void _updateAddressAtIndex(int index,
      AddressFormData Function(AddressFormData) updateFunction,) {
    if (!_isValidIndex(index)) return;

    final updatedAddresses = _copyAddressList();
    updatedAddresses[index] = updateFunction(updatedAddresses[index]);
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void _ensureDefaultAddressExists(List<AddressFormData> addresses) {
    if (addresses.isNotEmpty && !addresses.any((addr) => addr.isDefault)) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
  }

  void _clearAllDefaultFlags(List<AddressFormData> addresses,
      {required int exceptIndex}) {
    for (int i = 0; i < addresses.length; i++) {
      if (i != exceptIndex) {
        addresses[i] = addresses[i].copyWith(isDefault: false);
      }
    }
  }

  List<String> _getMunicipalitiesForDepartment(String department) {
    final locationData = state.locationData;
    return locationData != null
        ? _locationService.getMunicipalitiesForDepartment(
        locationData, department)
        : [];
  }

  AddressFormData _mapToFormData(AddressModel address) {
    return AddressFormData(
      id: address.id,
      country: address.country,
      department: address.department,
      municipality: address.municipality,
      streetAddress: address.streetAddress,
      complement: address.complement ?? '',
      isDefault: address.isDefault,
      availableMunicipalities: _getMunicipalitiesForDepartment(
          address.department),
    );
  }

  String? _validateAllAddresses() {
    for (int i = 0; i < state.addresses.length; i++) {
      final validation = _validateSingleAddress(state.addresses[i], i + 1);
      if (validation != null) return validation;
    }
    return null;
  }

  String? _validateSingleAddress(AddressFormData address, int position) {
    final requiredFields = [
      (address.country.isEmpty, 'país'),
      (address.department?.isEmpty ?? true, 'departamento'),
      (address.municipality?.isEmpty ?? true, 'municipio'),
      (address.streetAddress.isEmpty, 'dirección'),
    ];

    for (final (isEmpty, fieldName) in requiredFields) {
      if (isEmpty) {
        return 'El $fieldName es requerido en la dirección $position';
      }
    }
    return null;
  }
}
