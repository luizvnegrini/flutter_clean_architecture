import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  // ignore: null_aware_in_condition
  String validate(String value) => value?.isNotEmpty == true ? null : 'Campo obrigatório.';
}

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('should return null if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório.');
  });

  test('should return error if value is null', () {
    expect(sut.validate(null), 'Campo obrigatório.');
  });
}
