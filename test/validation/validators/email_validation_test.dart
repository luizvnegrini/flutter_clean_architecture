import 'package:home_automation/validation/protocols/ifield_validation.dart';
import 'package:test/test.dart';

class EmailValidation implements IFieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);

    return isValid ? null : 'Campo invávlido.';
  }
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });

  test('should return null if email is valid', () {
    expect(sut.validate('ca@flutter.com'), null);
  });

  test('should return error if email is invalid', () {
    expect(sut.validate('ca.com'), 'Campo invávlido.');
  });
}
