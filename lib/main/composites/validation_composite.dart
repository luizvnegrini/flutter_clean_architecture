import 'package:meta/meta.dart';

import '../../presentation/enums/enums.dart';
import '../../presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(input);

      if (error != null) return error;
    }

    return error;
  }
}
