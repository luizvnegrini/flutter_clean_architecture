import 'package:test/test.dart';

import 'package:home_automation/presentation/enums/validation_error_enum.dart';
import 'package:home_automation/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = const EmailValidation('any_field');
  });

  test('should return null on invalid cases', () {
    expect(sut.validate({}), null);
  });

  test('should return null if email is empty', () {
    final error = sut.validate({'any_field': ''});

    expect(error, null);
  });

  test('should return null if email is null', () {
    final error = sut.validate({'any_field': null});

    expect(error, null);
  });

  test('should return null if email is valid', () {
    expect(sut.validate({'any_field': 'ca@flutter.com'}), null);
  });

  test('should return error if email is invalid', () {
    expect(sut.validate({'any_field': 'ca.com'}), ValidationError.invalidField);
  });
}
