import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements IFieldValidation {
  @override
  final String field;

  @override
  List get props => [field];

  const RequiredFieldValidation(this.field);

  @override
  // ignore: null_aware_in_condition
  String validate(String value) => value?.isNotEmpty == true ? null : 'Campo obrigatório.';
}
