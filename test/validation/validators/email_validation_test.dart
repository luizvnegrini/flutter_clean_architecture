import 'package:home_automation/validation/protocols/ifield_validation.dart';
import 'package:test/test.dart';

class EmailValidation implements IFieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) => null;
}

void main() {
  test('should return null if email is empty', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate(null);

    expect(error, null);
  });
}
