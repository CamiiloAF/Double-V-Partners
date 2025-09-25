import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../theme/theme.dart';

class DropDownFilter<ModelDataType, ViewDataType>
    extends ReactiveFormField<ViewDataType, ViewDataType> {
  final DropdownSearchOnFind<ModelDataType> items;
  final String labelText;
  final void Function(ModelDataType?)? onSelect;
  final ModelDataType? selectedItem;
  final bool showSearchBox;
  final bool enabled;
  final bool required;
  final DropdownSearchFilterFn<ModelDataType>? filterFn;
  final DropdownSearchCompareFn<ModelDataType>? compareFn;
  final DropdownSearchItemAsString<ModelDataType>? itemAsString;

  final ViewDataType Function(ModelDataType?) itemAsViewData;

  DropDownFilter({
    required this.items,
    required this.labelText,
    required this.showSearchBox,
    required this.itemAsViewData,
    required super.formControlName,
    this.onSelect,
    this.filterFn,
    this.compareFn,
    this.itemAsString,
    this.selectedItem,
    this.enabled = true,
    this.required = true,
    super.key,
  }) : super(
         builder: (field) {
           return Builder(
             builder: (context) {
               final theme = getTheme(context);

               return InputDecorator(
                 baseStyle: theme.textTheme.bodySmall,
                 decoration: InputDecoration(
                   isDense: true,
                   contentPadding: const EdgeInsets.symmetric(vertical: 5),
                 ),
                 child: DropdownSearch<ModelDataType>(
                   autoValidateMode: AutovalidateMode.onUserInteraction,
                   compareFn: compareFn,
                   filterFn: filterFn,
                   itemAsString: itemAsString,
                   enabled: enabled,
                   validator: (value) {
                     if (required && value == null) {
                       return "Selección requerida";
                     } else {
                       return null;
                     }
                   },

                   popupProps: PopupProps.menu(
                     showSearchBox: showSearchBox,
                     searchDelay: Duration.zero,
                     showSelectedItems: true,
                     searchFieldProps: TextFieldProps(
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
                   items: items,
                   decoratorProps: DropDownDecoratorProps(
                     decoration: InputDecoration(
                       labelText: labelText,
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30),
                         borderSide: BorderSide(
                           color: theme.colorScheme.primary,
                         ),
                       ),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30),
                         borderSide: BorderSide(
                           color: theme.colorScheme.primary,
                         ),
                       ),
                     ),
                   ),
                   onChanged: (value) {
                     field.didChange(itemAsViewData(value));
                     onSelect?.call(value);
                   },
                   selectedItem: selectedItem,
                 ),
               );
             },
           );
         },
       );
}
