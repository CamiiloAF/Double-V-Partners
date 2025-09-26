import 'package:double_v_partners_tech/core/di/injection.dart';
import 'package:double_v_partners_tech/features/auth/presentation/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../core/domain/user.dart';
import '../../../../shared/router/app_routes.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/button/custom_button_widget.dart';
import '../../domain/model/address.dart';
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
  List<AddressModel> _currentAddresses = [];
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _currentAddresses = List.from(widget.params.initialAddresses);
  }

  void _onAddressesChanged(List<dynamic> addresses) {
    setState(() {
      _currentAddresses = addresses.cast<AddressModel>();
      _hasChanges = true;
    });
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

  // void _showSuccess() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Direcciones guardadas exitosamente'),
  //       backgroundColor: AppColorsTheme.success,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

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

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Descartar cambios?'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir sin guardar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColorsTheme.error),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
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
                context.pushReplacementNamed(AppRoutes.profile);
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
                          onAddressesChanged: _onAddressesChanged,
                        ),
                      ),
                    ),
                    // Botón inferior fijo
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColorsTheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Resumen de direcciones
                          if (_currentAddresses.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColorsTheme.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColorsTheme.success.withOpacity(
                                    0.2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: AppColorsTheme.success,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${_currentAddresses.length} ${_currentAddresses.length == 1 ? 'dirección lista' : 'direcciones listas'} para guardar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColorsTheme.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Botón de guardar
                          CustomButtonWidget(
                            text:
                                'Guardar Direcciones (${_currentAddresses.length})',
                            onPressed: () => _saveAddresses(context, state),
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
      ),
    );
  }
}
