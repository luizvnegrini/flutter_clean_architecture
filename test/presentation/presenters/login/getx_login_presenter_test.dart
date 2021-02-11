import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:home_automation/domain/enums/enums.dart';
import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/domain/usecases/usecases.dart';
import 'package:home_automation/presentation/presenters/presenters.dart';
import 'package:home_automation/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements IValidation {}

class AuthenticationSpy extends Mock implements IAuthentication {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetxLoginPresenter sut;
  AuthenticationSpy authentication;
  SaveCurrentAccountSpy saveCurrentAccount;
  ValidationSpy validation;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field ?? anyNamed('field'), value: anyNamed('value')));

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAuthentication();
  });

  test('should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateEmail(email)..validateEmail(email);
  });

  test('should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validateEmail(email)..validateEmail(email);
  });

  test('should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePassword(password)..validatePassword(password);
  });

  test('should emit null if password validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut..validatePassword(password)..validatePassword(password);
  });

  test('should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream.listen((error) => expect(error, 'error'));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut
      ..validateEmail(password)
      ..validatePassword(password);
  });

  test('should emit password error if validation fails', () async {
    sut.emailErrorStream.listen((error) => expect(error, null));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

    // ignore: unawaited_futures
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(password);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('should call authentication with correct values', () async {
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('should call SaveCurrentAccount with correct value', () async {
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('should emit correct events on Authentication success', () async {
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve')));

    await sut.auth();
  });

  test('should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut
      ..validateEmail(email)
      ..validatePassword(password);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve')));

    await sut.auth();
  });
}
