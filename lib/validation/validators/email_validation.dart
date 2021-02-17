import 'package:equatable/equatable.dart';

import '../../presentation/enums/validation_error_enum.dart';
import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements IFieldValidation {
  @override
  final String field;

  @override
  List get props => [field];

  const EmailValidation(this.field);

  @override
  ValidationError validate(Map input) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    final isValid = input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);

    return isValid ? null : ValidationError.invalidField;
  }
}
