import 'package:reactive_forms/reactive_forms.dart';

extension FormGroupExtensions on FormGroup {
  void setFieldValue(String fieldName, dynamic value) {
    control(fieldName).value = value;
  }

  void clearValue(String fieldName) {
    setFieldValue(fieldName, null);
  }

  T getFieldValue<T>(String fieldName) {
    return control(fieldName).value as T;
  }
}
