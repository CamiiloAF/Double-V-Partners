import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/result_state.dart';
import '../../../features/auth/domain/model/address.dart';
import '../../../features/auth/presentation/sign_up/widgets/section_container.dart';
import '../../theme/app_colors_theme.dart';
import '../../widgets/forms/custom_form.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/inputs/drop_down_filter.dart';
import 'cubit/address_cubit.dart';

class AddressForm extends StatelessWidget {
  const AddressForm({super.key, this.initialAddresses = const []});

  final List<AddressModel> initialAddresses;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = context.read<AddressCubit>();

        if (initialAddresses.isNotEmpty) {
          cubit.loadExistingAddresses(initialAddresses.cast());
        } else {
          cubit.addNewAddress();
        }
        return cubit;
      },
      child: const _AddressFormView(),
    );
  }
}

class _AddressFormView extends StatefulWidget {
  const _AddressFormView();

  @override
  State<_AddressFormView> createState() => _AddressFormViewState();
}

class _AddressFormViewState extends State<_AddressFormView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state.locationDataResult is Error) {
          final error = (state.locationDataResult as Error).error.message;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error cargando ubicaciones: ${error}'),
              backgroundColor: AppColorsTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoadingLocations) {
          return const Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColorsTheme.primary,
                ),
              ),
            ),
          );
        }

        return CustomForm(
          formGroup: state.formGroup,
          fields: [
            _buildHeader(context, state),
            const SizedBox(height: 24),

            ...List.generate(
              state.addresses.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildAddressSection(context, state, index),
              ),
            ),

            _buildAddNewAddressButton(context),

            _buildInfoCard(),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AddressState state) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColorsTheme.primary, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Direcciones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColorsTheme.headline,
                ),
              ),
              Text(
                '${state.addressCount} ${state.addressCount == 1 ? 'dirección agregada' : 'direcciones agregadas'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColorsTheme.subtitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    AddressState state,
    int index,
  ) {
    final address = state.addresses[index];
    final isFirstAddress = index == 0;

    return FormSectionContainer(
      title: isFirstAddress
          ? 'Dirección Principal ${address.isDefault ? '(Por defecto)' : ''}'
          : 'Dirección ${index + 1} ${address.isDefault ? '(Por defecto)' : ''}',
      icon: address.isDefault ? Icons.home : Icons.location_on_outlined,
      showRemoveButton: !isFirstAddress,
      onRemove: () => context.read<AddressCubit>().removeAddress(index),
      trailing: address.isComplete
          ? const Icon(Icons.check_circle, color: AppColorsTheme.success)
          : const Icon(
              Icons.radio_button_unchecked,
              color: AppColorsTheme.subtitle,
            ),
      children: [
        DropDownFilter<String>(
          formControlName: state.countryInputFor(index),
          labelText: 'País *',
          selectedItem: address.country,
          hintText: 'Selecciona el país',
          onChanged: (value) {
            context.read<AddressCubit>().onChangeCountry(index, value ?? '');
          },
          items: const ['Colombia'],
          prefixIcon: const Icon(Icons.public, color: AppColorsTheme.subtitle),
          showSearchBox: false,
        ),
        const SizedBox(height: 20),

        DropDownFilter<String>(
          formControlName: state.departmentInputFor(index),
          labelText: 'Departamento *',
          hintText: 'Selecciona el departamento',
          selectedItem: address.department,
          items: state.availableDepartments,
          onChanged: (value) {
            context.read<AddressCubit>().onChangeDepartment(index, value ?? '');
          },
          prefixIcon: const Icon(
            Icons.map_outlined,
            color: AppColorsTheme.subtitle,
          ),
          showSearchBox: true,
        ),
        const SizedBox(height: 20),
        DropDownFilter<String>(
          formControlName: state.municipalityInputFor(index),
          labelText: 'Municipio *',
          hintText: 'Selecciona el municipio',
          selectedItem: address.municipality,
          items: address.availableMunicipalities,
          onChanged: (value) {
            context.read<AddressCubit>().onChangeMunicipality(
              index,
              value ?? '',
            );
          },
          prefixIcon: const Icon(
            Icons.location_city_outlined,
            color: AppColorsTheme.subtitle,
          ),
          showSearchBox: true,
        ),
        const SizedBox(height: 20),
        CustomTextField<String>(
          formControlName: state.streetAddressInputFor(index),
          labelText: 'Dirección *',
          hintText: 'Calle, carrera, número, etc.',
          onChanged: (value) {
            context.read<AddressCubit>().onChangeStreetAddress(
              index,
              value.value ?? '',
            );
          },
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(
            Icons.home_outlined,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),

        CustomTextField<String>(
          formControlName: state.complementInputFor(index),
          labelText: 'Complemento',
          hintText: 'Apartamento, piso, torre, etc. (opcional)',
          onChanged: (value) {
            context.read<AddressCubit>().onChangeComplement(
              index,
              value.value ?? '',
            );
          },
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(
            Icons.apartment_outlined,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),

        CheckboxListTile(
          title: const Text(
            'Marcar como dirección principal',
            style: TextStyle(fontSize: 14, color: AppColorsTheme.headline),
          ),
          subtitle: const Text(
            'Esta será tu dirección por defecto',
            style: TextStyle(fontSize: 12, color: AppColorsTheme.subtitle),
          ),
          value: address.isDefault,
          onChanged: (value) {
            if (value != null) {
              context.read<AddressCubit>().onChangeDefaultAddress(
                index,
                value: value,
              );
            }
          },
          activeColor: AppColorsTheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAddNewAddressButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: OutlinedButton.icon(
        onPressed: () => context.read<AddressCubit>().addNewAddress(),
        icon: const Icon(Icons.add, color: AppColorsTheme.primary),
        label: const Text(
          'Agregar nueva dirección',
          style: TextStyle(
            color: AppColorsTheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColorsTheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorsTheme.info.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorsTheme.info.withValues(alpha: .2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColorsTheme.info, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información sobre direcciones',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColorsTheme.info,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Puedes agregar múltiples direcciones y marcar una como principal. La dirección principal será tu dirección por defecto.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColorsTheme.subtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
