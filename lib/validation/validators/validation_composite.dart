import 'package:meta/meta.dart';

import '../../presentation/enums/enums.dart';
import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);

      if (error != null) return error;
    }

    return error;
  }
}
