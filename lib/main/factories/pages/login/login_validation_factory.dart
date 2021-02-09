import '../../../../presentation/protocols/ivalidation.dart';
import '../../../../validation/protocols/ifield_validation.dart';
import '../../../../validation/validators/validators.dart';

IValidation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<IFieldValidation> makeLoginValidations() => [
      const RequiredFieldValidation('email'),
      const EmailValidation('email'),
      const RequiredFieldValidation('password'),
    ];
