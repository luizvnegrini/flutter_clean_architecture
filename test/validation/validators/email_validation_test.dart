import 'package:test/test.dart';

import 'package:home_automation/validation/validators/validators.dart';

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
