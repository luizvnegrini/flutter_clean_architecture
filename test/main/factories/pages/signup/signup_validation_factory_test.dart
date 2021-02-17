import 'package:test/test.dart';

import 'package:home_automation/main/factories/pages/pages.dart';
import 'package:home_automation/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(validations, [
      const RequiredFieldValidation('name'),
      const MinLengthValidation(field: 'name', minLength: 10),
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password'),
      const MinLengthValidation(field: 'password', minLength: 3),
      const RequiredFieldValidation('passwordConfirmation'),
      const CompareFieldsValidation(field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}
