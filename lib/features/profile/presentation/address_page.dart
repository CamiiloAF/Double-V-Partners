import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/domain/result_state.dart';
import '../../../core/domain/user.dart';
import '../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../shared/presentation/addresses/address_form.dart';
import '../../../shared/presentation/addresses/cubit/address_cubit.dart';
import '../../../shared/theme/app_colors_theme.dart';
import '../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import '../../../shared/widgets/button/custom_button_widget.dart';
import '../../../shared/widgets/containers/address_button_container.dart';
import 'cubit/update_profile_cubit.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({required this.currentUser, super.key});

  final UserModel currentUser;

  Future<void> _saveAddresses(BuildContext context, AddressState state) async {
    final error = context.read<AddressCubit>().validateAddresses();

    if (error != null) {
      showSnackBarError(error, context);
      return;
    }

    final userToUpdate = currentUser.copyWith(
      addresses: state.addresses.map((e) => e.toAddressModel()).toList(),
    );
    await context.read<UpdateProfileCubit>().updateUserInformation(
      userToUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddressCubit>()),
        BlocProvider(create: (context) => getIt<UpdateProfileCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColorsTheme.scaffold,
        appBar: AppBar(
          title: const Text(
            'Actualizar Direcciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColorsTheme.headline,
            ),
          ),
          backgroundColor: AppColorsTheme.surface,
          elevation: 0,
        ),
        body: BlocListener<UpdateProfileCubit, ResultState<UserModel>>(
          listener: (context, state) {
            if (state is Error) {
              showErrorDialog(context, content: (state as Error).error.message);
              return;
            }

            if (state is Data) {
              context.read<CurrentUserCubit>().setCurrentUser(
                (state as Data<UserModel>).data,
              );

              showSuccessUpdateSnackBar(context);
            }
          },
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, addressState) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: AddressForm(
                        initialAddresses: currentUser.addresses,
                      ),
                    ),
                  ),
                  AddressButtonContainer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<UpdateProfileCubit, ResultState<UserModel>>(
                          builder: (context, updateProfileState) {
                            return CustomButtonWidget(
                              text:
                                  'Guardar Direcciones (${addressState.addressCount})',
                              onPressed: () =>
                                  _saveAddresses(context, addressState),
                              isLoading: updateProfileState is Loading,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
