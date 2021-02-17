import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:home_automation/validation/validators/validators.dart';
import 'package:home_automation/presentation/enums/enums.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = const MinLengthValidation(field: 'any_field', minLength: 5);
  });

  test('should return error if value is empty', () {
    final error = sut.validate({'any_field': ''});

    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is null', () {
    final error = sut.validate({'any_field': null});

    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is less then min length', () {
    final error = sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)});

    expect(error, ValidationError.invalidField);
  });

  test('should return null if value is equal than min length', () {
    final error = sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)});

    expect(error, null);
  });

  test('should return null if value is bigger than min length', () {
    final error = sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)});

    expect(error, null);
  });
}
