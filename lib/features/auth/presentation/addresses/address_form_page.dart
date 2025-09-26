import 'package:double_v_partners_tech/core/di/injection.dart';
import 'package:double_v_partners_tech/core/extensions/go_router.dart';
import 'package:double_v_partners_tech/features/auth/presentation/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/button/custom_button_widget.dart';
import '../cubit/current_user_cubit.dart';
import '../cubit/sign_up/sign_up_cubit.dart';
import '../sign_up/widgets/address_form.dart';
import 'params.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key, required this.params});

  final AddressPageParams params;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  @override
  void initState() {
    super.initState();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColorsTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveAddresses(BuildContext context, AddressState state) async {
    final error = context.read<AddressCubit>().validateAddresses();

    if (error != null) {
      _showError(error);
      return;
    }

    context.read<SignUpCubit>().submitSignUp(
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
          title: Text(
            widget.params.title,
            style: const TextStyle(
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: AddressForm(
                        initialAddresses: widget.params.initialAddresses,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColorsTheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
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
