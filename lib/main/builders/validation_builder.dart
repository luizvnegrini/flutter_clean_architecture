import '../../validation/protocols/ifield_validation.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  // ignore: unused_field
  static ValidationBuilder _instance;
  String fieldName;
  List<IFieldValidation> validations = [];

  ValidationBuilder._();

  // ignore: prefer_constructors_over_static_methods
  static ValidationBuilder field(String fieldName) => _instance = ValidationBuilder._()..fieldName = fieldName;

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

  // ignore: avoid_returning_this
  ValidationBuilder min(int minLength) {
    validations.add(MinLengthValidation(field: fieldName, minLength: minLength));
    return this;
  }

  // ignore: avoid_returning_this
  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldsValidation(field: fieldName, fieldToCompare: fieldToCompare));
    return this;
  }

  List<IFieldValidation> build() => validations;
}
