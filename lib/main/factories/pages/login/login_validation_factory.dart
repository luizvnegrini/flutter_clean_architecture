import 'package:home_automation/presentation/protocols/ivalidation.dart';
import 'package:home_automation/validation/validators/validators.dart';

IValidation makeLoginValidation() => ValidationComposite([
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
