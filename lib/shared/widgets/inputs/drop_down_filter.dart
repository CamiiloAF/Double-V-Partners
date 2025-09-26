import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class DropDownFilter<ModelDataType> extends StatefulWidget {
  final String formControlName;
  final List<ModelDataType> items;
  final String labelText;
  final String? hintText;
  final void Function(ModelDataType?)? onChanged;
  final ModelDataType? selectedItem;
  final bool showSearchBox;
  final bool required;

  final Widget? prefixIcon;

  const DropDownFilter({
    required this.items,
    required this.labelText,
    required this.showSearchBox,
    required this.formControlName,
    this.onChanged,
    this.selectedItem,
    this.prefixIcon,
    this.hintText,
    this.required = true,
    super.key,
  });

  @override
  State<DropDownFilter<ModelDataType>> createState() =>
      _DropDownFilterState<ModelDataType>();
}

class _DropDownFilterState<ModelDataType>
    extends State<DropDownFilter<ModelDataType>> {
  ModelDataType? selectedItem;

  @override
  void initState() {
    selectedItem = widget.selectedItem;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropDownFilter<ModelDataType> oldWidget) {
    setState(() {
      selectedItem = widget.selectedItem;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);

    return InputDecorator(
      baseStyle: theme.textTheme.bodySmall,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
      ),
      child: DropdownSearch<ModelDataType>(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.required && value == null) {
            return 'Selección requerida';
          } else {
            return null;
          }
        },

        popupProps: PopupProps.menu(
          showSearchBox: widget.showSearchBox,
          searchDelay: Duration.zero,
          showSelectedItems: true,
          searchFieldProps: const TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Buscar...',
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
            ),
          ),
          emptyBuilder: (context, searchEntry) => Align(
            alignment: AlignmentDirectional.topCenter,
            child: Text('No hay resultados para "$searchEntry"'),
          ),
        ),
        items: (filter, loadProps) => widget.items,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: widget.labelText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: widget.prefixIcon,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
        selectedItem: selectedItem,
      ),
    );
  }
}
