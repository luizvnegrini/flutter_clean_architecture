import '../../validation/protocols/ifield_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  // ignore: unused_field
  static ValidationBuilder _instance;

  String fieldName;
  List<IFieldValidation> validations = [];

  // ignore: prefer_constructors_over_static_methods
  static ValidationBuilder field(String fieldName) => _instance = ValidationBuilder()..fieldName = fieldName;

  // ignore: avoid_returning_this
  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  // ignore: avoid_returning_this
  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  List<IFieldValidation> build() => validations;
}
