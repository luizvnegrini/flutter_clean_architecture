import '../../presentation/enums/validation_error_enum.dart';

abstract class IFieldValidation {
  String get field;
  ValidationError validate(Map input);
}
