import 'package:home_automation/validation/protocols/ifield_validation.dart';
import 'package:test/test.dart';

class EmailValidation implements IFieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String validate(String value) => null;
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });
}
