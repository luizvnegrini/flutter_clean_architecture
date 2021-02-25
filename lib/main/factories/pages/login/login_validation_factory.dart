import '../../../../main/composites/composites.dart';
import '../../../../presentation/protocols/ivalidation.dart';
import '../../../../validation/protocols/ifield_validation.dart';
import '../../../builders/validation_builder.dart';

IValidation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<IFieldValidation> makeLoginValidations() => [
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().min(3).build(),
    ];
