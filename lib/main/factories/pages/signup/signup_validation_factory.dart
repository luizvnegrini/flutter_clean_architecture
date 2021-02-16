import '../../../../presentation/protocols/ivalidation.dart';
import '../../../../validation/protocols/ifield_validation.dart';
import '../../../../validation/validators/validators.dart';
import '../../../builders/validation_builder.dart';

IValidation makeSignUpValidation() => ValidationComposite(makeSignUpValidations());

List<IFieldValidation> makeSignUpValidations() => [
      ...ValidationBuilder.field('name').required().build(),
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().build(),
      ...ValidationBuilder.field('passwordConfirmation').required().build(),
    ];
