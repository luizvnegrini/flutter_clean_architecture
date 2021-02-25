import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/ivalidation.dart';
import '../../../../validation/protocols/ifield_validation.dart';
import '../../../builders/validation_builder.dart';

IValidation makeSignUpValidation() => ValidationComposite(makeSignUpValidations());

List<IFieldValidation> makeSignUpValidations() => [
      ...ValidationBuilder.field('name').required().min(10).build(),
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().min(3).build(),
      ...ValidationBuilder.field('passwordConfirmation').required().sameAs('password').build(),
    ];
