import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/enums/validation_error_enum.dart';
import '../../validation/protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements IFieldValidation {
  @override
  final String field;
  final String fieldToCompare;

  @override
  List get props => [field, fieldToCompare];

  const CompareFieldsValidation({
    @required this.field,
    @required this.fieldToCompare,
  });

  @override
  ValidationError validate(Map input) =>
      input[field] != null && input[fieldToCompare] != null && input[field] != input[fieldToCompare] ? ValidationError.invalidField : null;
}
