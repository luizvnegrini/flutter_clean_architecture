import 'package:test/test.dart';

import 'package:home_automation/validation/validators/validators.dart';
import 'package:home_automation/presentation/enums/enums.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('should return null on invalid cases', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });

  test('should return error if values are not equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };

    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('should return null if values are equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };

    expect(sut.validate(formData), null);
  });
}
