import 'package:faker/faker.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/presentation/presenters/presenters.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/presentation/enums/enums.dart';
import 'package:home_automation/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements IValidation {}

class AddAccountSpy extends Mock implements IAddAccount {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  AddAccountSpy addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;

  String name;
  String email;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field ?? anyNamed('field'), input: anyNamed('input')));
  PostExpectation mockAddAccountCall() => when(addAccount.add(any));
  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAddAccount();
  });

  test('should call validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateName(name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('should emit invalidField error if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateName(name)..validateName(name);
  });

  test('should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateName(name)..validateName(name);
  });

  test('should emit null if name validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateName(name)..validateName(name);
  });

  test('should call validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('should emit invalidField error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateEmail(email)..validateEmail(email);
  });

  test('should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateEmail(email)..validateEmail(email);
  });

  test('should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateEmail(email)..validateEmail(email);
  });

  test('should call validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePassword(password)..validatePassword(password);
  });

  test('should emit null if password validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePassword(password)..validatePassword(password);
  });

  test('should emit invalidFieldError if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePassword(password)..validatePassword(password);
  });

  test('should call validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(validation.validate(field: 'passwordConfirmation', input: formData)).called(1);
  });

  test('should emit requiredFieldError if passwordConfirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePasswordConfirmation(passwordConfirmation)..validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit null if passwordConfirmation validation succeeds', () {
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePasswordConfirmation(passwordConfirmation)..validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit invalidFieldError if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePasswordConfirmation(passwordConfirmation)..validatePasswordConfirmation(passwordConfirmation);
  });

  test('should enable form button if all fields are valid', () async {
    // ignore: unawaited_futures
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('should call AddAccount with correct values', () async {
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(addAccount.add(AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ))).called(1);
  });

  test('should call SaveCurrentAccount with correct value', () async {
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('should emit correct events on AddAccount success', () async {
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emits(null));
    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();
  });

  test('should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('should change to home page on success', () async {
    sut
      ..validateName(name)
      ..validateEmail(email)
      ..validatePassword(password)
      ..validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('should go to signUp page on link click', () async {
    // ignore: unawaited_futures
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.goToLogin();
  });
}
