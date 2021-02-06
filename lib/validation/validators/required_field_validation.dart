import '../protocols/protocols.dart';

class RequiredFieldValidation implements IFieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  // ignore: null_aware_in_condition
  String validate(String value) => value?.isNotEmpty == true ? null : 'Campo obrigatório.';
}
