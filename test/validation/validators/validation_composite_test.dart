import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/presentation/protocols/protocols.dart';
import 'package:home_automation/validation/protocols/protocols.dart';

import 'package:test/test.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) => null;
}

class FieldValidationSpy extends Mock implements IFieldValidation {}

void main() {
  test('should return null if all validation returns null or empty', () {
    final validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    final validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');

    final sut = ValidationComposite([validation1, validation2]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
