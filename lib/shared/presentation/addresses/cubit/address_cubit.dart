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

  Future<void> _loadLocationData() async {
    emit(state.copyWith(locationDataResult: const ResultState.loading()));

    try {
      final locationData = await _locationService.loadColombiaData();
      final departments = _locationService.getDepartmentNames(locationData);

      emit(
        state.copyWith(
          locationDataResult: ResultState.data(data: locationData),
          availableDepartments: departments,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          locationDataResult: ResultState.error(
            error: DomainException(message: 'Error cargando la información.'),
          ),
        ),
      );
    }
  }

  void addNewAddress() {
    final newAddress = AddressFormData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    final updatedAddresses = [...state.addresses, newAddress];
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void removeAddress(int index) {
    if (state.addresses.length <= 1) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    updatedAddresses.removeAt(index);

    if (updatedAddresses.isNotEmpty &&
        !updatedAddresses.any((addr) => addr.isDefault)) {
      updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
    }

    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeCountry(int index, String country) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    final address = updatedAddresses[index];

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeDepartment(int index, String department) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    var address = updatedAddresses[index];

    address = address.copyWith(
      department: department,
      municipality: null,
      availableMunicipalities: [],
    );

    final locationData = state.locationData;
    if (locationData != null) {
      final municipalities = _locationService.getMunicipalitiesForDepartment(
        locationData,
        department,
      );
      address = address.copyWith(availableMunicipalities: municipalities);
    }

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeMunicipality(int index, String municipality) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    var address = updatedAddresses[index];
    address = address.copyWith(municipality: municipality);

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeDefaultAddress(int index, bool value) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    var address = updatedAddresses[index];

    if (value == true) {
      for (var i = 0; i < updatedAddresses.length; i++) {
        if (i != index) {
          updatedAddresses[i] = updatedAddresses[i].copyWith(isDefault: false);
        }
      }
    }
    address = address.copyWith(isDefault: value);

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeStreetAddress(int index, String streetAddress) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    var address = updatedAddresses[index];
    address = address.copyWith(streetAddress: streetAddress);

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void onChangeComplement(int index, String complement) {
    if (index >= state.addresses.length) return;

    final updatedAddresses = List<AddressFormData>.from(state.addresses);
    var address = updatedAddresses[index];
    address = address.copyWith(complement: complement);

    updatedAddresses[index] = address;
    emit(state.copyWith(addresses: updatedAddresses));
  }

  String? validateAddresses() {
    if (state.addresses.isEmpty) {
      return 'Debes agregar al menos una dirección';
    }

    if (!state.addresses.any((addr) => addr.isDefault)) {
      return 'Debes marcar al menos una dirección como principal';
    }

    for (var i = 0; i < state.addresses.length; i++) {
      final address = state.addresses[i];
      final validation = _validateSingleAddress(address, i + 1);
      if (validation != null) return validation;
    }

    return null;
  }

  String? _validateSingleAddress(AddressFormData address, int position) {
    if (address.country.isEmpty) {
      return 'El país es requerido en la dirección $position';
    }
    if (address.department?.isEmpty ?? false) {
      return 'El departamento es requerido en la dirección $position';
    }
    if (address.municipality?.isEmpty ?? false) {
      return 'El municipio es requerido en la dirección $position';
    }
    if (address.streetAddress.isEmpty) {
      return 'La dirección es requerida en la dirección $position';
    }

    return null;
  }

  void loadExistingAddresses(List<AddressModel> addresses) {
    final locationData = state.locationData;
    final formDataList = addresses
        .map(
          (addr) => AddressFormData(
            id: addr.id,
            country: addr.country,
            department: addr.department,
            municipality: addr.municipality,
            streetAddress: addr.streetAddress,
            complement: addr.complement ?? '',
            isDefault: addr.isDefault,
            availableMunicipalities: locationData != null
                ? _locationService.getMunicipalitiesForDepartment(
                    locationData,
                    addr.department,
                  )
                : [],
          ),
        )
        .toList();

    // Al emitir el nuevo estado, el FormGroup se reconstruirá automáticamente
    // con los valores correctos gracias a _buildDynamicFormGroup()
    emit(state.copyWith(addresses: formDataList));
  }

  void resetForm() {
    emit(
      state.copyWith(
        addresses: [
          AddressFormData(id: DateTime.now().millisecondsSinceEpoch.toString()),
        ],
      ),
    );
  }
}
