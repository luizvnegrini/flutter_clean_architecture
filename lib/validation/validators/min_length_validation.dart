import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/enums/enums.dart';
import '../../validation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements IFieldValidation {
  @override
  final String field;
  final int minLength;

  @override
  List get props => [field, minLength];

  @override
  ValidationError validate(Map input) => input[field] != null && input[field].length >= minLength ? null : ValidationError.invalidField;

  const MinLengthValidation({@required this.field, @required this.minLength});
}
