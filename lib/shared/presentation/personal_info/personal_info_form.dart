import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/di/injection.dart';
import '../../../core/domain/user.dart';
import '../../theme/app_colors_theme.dart';
import '../../widgets/button/custom_button_widget.dart';
import '../../widgets/containers/section_container.dart';
import '../../widgets/forms/custom_form.dart';
import '../../widgets/inputs/custom_text_field.dart';
import 'cubit/personal_info_cubit.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({
    required this.onCompleteForm,
    this.showPasswordField = false,
    this.isLoading = false,
    this.initialUser,
    super.key,
  });

  final bool showPasswordField;
  final UserModel? initialUser;
  final ValueChanged<UserModel> onCompleteForm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<PersonalInfoCubit>();
        cubit.initializeForm(
          showPasswordField: showPasswordField,
          initialUser: initialUser,
        );
        return cubit;
      },
      child: _PersonalInfoFormView(
        showPasswordField: showPasswordField,
        onCompleteForm: onCompleteForm,
        isLoading: isLoading,
      ),
    );
  }
}

class _PersonalInfoFormView extends StatefulWidget {
  const _PersonalInfoFormView({
    required this.showPasswordField,
    required this.onCompleteForm,
    required this.isLoading,
  });

  final bool showPasswordField;
  final ValueChanged<UserModel> onCompleteForm;
  final bool isLoading;

  @override
  State<_PersonalInfoFormView> createState() => _PersonalInfoFormViewState();
}

class _PersonalInfoFormViewState extends State<_PersonalInfoFormView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      builder: (context, state) {
        return CustomForm(
          formGroup: state.formGroup,
          fields: [
            FormSectionContainer(
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
                if (widget.showPasswordField) ...[
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
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColorsTheme.subtitle,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ReactiveDatePicker<DateTime>(
                  formControlName: state.birthDateInput,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, picker, child) {
                    return CustomTextField(
                      formControlName: state.birthDateInput,
                      labelText: 'Fecha de nacimiento *',
                      readOnly: true,
                      onTap: (_) {
                        picker.showPicker();
                      },
                      valueAccessor: DateTimeValueAccessor(
                        dateTimeFormat: DateFormat('dd/MM/yyyy'),
                      ),
                      prefixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColorsTheme.subtitle,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    return CustomButtonWidget(
                      text: 'Continuar',
                      isLoading: widget.isLoading,
                      onPressed: formGroup.valid
                          ? () {
                              final user = widget.showPasswordField
                                  ? context
                                        .read<PersonalInfoCubit>()
                                        .buildSignUpModel()
                                  : context
                                        .read<PersonalInfoCubit>()
                                        .buildUserModel();

                              widget.onCompleteForm(user);
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
