import 'package:test/test.dart';

import 'package:home_automation/main/factories/pages/pages.dart';
import 'package:home_automation/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password'),
    ]);
  });
}
