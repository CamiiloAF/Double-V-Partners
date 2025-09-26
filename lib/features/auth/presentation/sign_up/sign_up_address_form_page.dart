import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../core/extensions/go_router.dart';
import '../../../../core/presentation/cubit/current_user_cubit.dart';
import '../../../../shared/presentation/addresses/address_form.dart';
import '../../../../shared/presentation/addresses/cubit/address_cubit.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/alert_dialogs/alert_dialogs.dart';
import '../../../../shared/widgets/button/custom_button_widget.dart';
import '../../../../shared/widgets/containers/address_button_container.dart';
import '../cubit/sign_up/sign_up_cubit.dart';

class SignUpAddressFormPage extends StatelessWidget {
  const SignUpAddressFormPage({super.key});


  Future<void> _saveAddresses(BuildContext context, AddressState state) async {
    final error = context.read<AddressCubit>().validateAddresses();

    if (error != null) {
      showSnackBarError(error, context);
      return;
    }

    await context.read<SignUpCubit>().submitSignUp(
      state.addresses.map((e) => e.toAddressModel()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressCubit>(),
      child: Scaffold(
        backgroundColor: AppColorsTheme.scaffold,
        appBar: AppBar(
          title: const Text(
            'Direcciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColorsTheme.headline,
            ),
          ),
          backgroundColor: AppColorsTheme.surface,
          elevation: 0,
        ),
        body: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            final result = state.signUpResult;
            if (result is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text((result as Error).error.message),
                  backgroundColor: AppColorsTheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            if (result is Data) {
              context.read<CurrentUserCubit>().setCurrentUser(
                (result as Data<UserModel>).data,
              );
              context.goAndClearStack(AppRoutes.profile);
            }
          },
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              return Column(
                children: [
                  const Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: AddressForm(),
                    ),
                  ),
                  AddressButtonContainer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<SignUpCubit, SignUpState>(
                          builder: (context, signUpState) {
                            return CustomButtonWidget(
                              text:
                                  'Guardar Direcciones (${state.addressCount})',
                              onPressed: () => _saveAddresses(context, state),
                              isLoading: signUpState.signUpResult is Loading,
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
