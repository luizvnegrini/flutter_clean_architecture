import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);

      if (error?.isNotEmpty == true) return error;
    }

    return error;
  }
}
