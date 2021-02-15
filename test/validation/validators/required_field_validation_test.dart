import 'package:test/test.dart';

import 'package:home_automation/presentation/enums/validation_error_enum.dart';
import 'package:home_automation/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('should return null if value is empty', () {
    expect(sut.validate(''), ValidationError.requiredField);
  });

  test('should return error if value is null', () {
    expect(sut.validate(null), ValidationError.requiredField);
  });
}
