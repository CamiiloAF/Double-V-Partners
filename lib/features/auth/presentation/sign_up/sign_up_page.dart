import 'package:double_v_partners_tech/features/auth/presentation/addresses/params.dart';
import 'package:double_v_partners_tech/shared/router/app_routes.dart';
import 'package:double_v_partners_tech/shared/widgets/button/custom_button_widget.dart';
import 'package:double_v_partners_tech/shared/widgets/forms/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/domain/result_state.dart';
import '../../../../shared/theme/app_colors_theme.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../cubit/sign_up/sign_up_cubit.dart';
import 'widgets/section_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.scaffold,
      appBar: AppBar(
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColorsTheme.headline,
          ),
        ),
        backgroundColor: AppColorsTheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          if (state.signUpResult is Loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColorsTheme.primary,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: CustomForm(
              formGroup: state.formGroup,
              fields: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColorsTheme.headline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completa la información para crear tu cuenta',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColorsTheme.subtitle,
                  ),
                ),
                const SizedBox(height: 32),
                _buildPersonalInfoSection(context, state),
                // const SizedBox(height: 32),
                // _buildAddressSection(context, state),
                const SizedBox(height: 40),
                // _buildSubmitButton(context, state),
                // const SizedBox(height: 24),
                ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    return CustomButtonWidget(
                      text: 'Continuar',
                      onPressed: formGroup.valid
                          ? () {
                              context.pushNamed(
                                AppRoutes.signUpAddress,
                                extra: AddressPageParams(
                                  initialAddresses: [],
                                  title: 'Direcciones',
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, SignUpState state) {
    return FormSectionContainer(
      title: 'Información Personal',
      icon: Icons.person_outline,
      children: [
        CustomTextField(
          formControlName: state.firstNameInput,
          labelText: 'Nombre *',
          hintText: 'Ingresa tu nombre',
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          formControlName: state.lastNameInput,
          labelText: 'Apellido *',
          hintText: 'Ingresa tu apellido',
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          formControlName: state.emailInput,
          labelText: 'Correo Electrónico *',
          hintText: 'ejemplo@correo.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColorsTheme.subtitle,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          formControlName: state.passwordInput,
          labelText: 'Contraseña *',
          hintText: 'Mínimo 6 caracteres',
          obscureText: _obscurePassword,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColorsTheme.subtitle,
          ),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColorsTheme.subtitle,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ReactiveDatePicker<DateTime>(
          formControlName: state.birthDateInput,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, picker, child) {
            return CustomTextField(
              formControlName: state.birthDateInput,
              labelText: 'Fecha de nacimiento',
              readOnly: true,
              onTap: (_) {
                picker.showPicker();
              },
              valueAccessor: DateTimeValueAccessor(
                dateTimeFormat: DateFormat('dd/MM/yyyy'),
              ),
            );
          },
        ),
      ],
    );
  }

  // void _showSuccessDialog(BuildContext context, UserModel user) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             decoration: const BoxDecoration(
  //               color: AppColorsTheme.success,
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.check, color: Colors.white, size: 32),
  //           ),
  //           const SizedBox(height: 24),
  //           const Text(
  //             '¡Cuenta creada exitosamente!',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //               color: AppColorsTheme.headline,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 16),
  //           Text(
  //             'Bienvenido ${user.fullName}',
  //             style: const TextStyle(
  //               fontSize: 16,
  //               color: AppColorsTheme.subtitle,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 24),
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(dialogContext).pop();
  //                 context.pop(); // Return to previous screen
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColorsTheme.primary,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //               ),
  //               child: const Text(
  //                 'Continuar',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
