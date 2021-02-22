import './translations.dart';

class PtBr implements Translations {
  @override
  String get addAccount => 'Criar conta';
  @override
  String get email => 'Email';
  @override
  String get password => 'Senha';
  @override
  String get enter => 'Entrar';
  @override
  String get name => 'Nome';
  @override
  String get confirmPassword => 'Confirmar senha';
  @override
  String get login => 'Login';
  @override
  String get signUp => 'Registrar.';
  @override
  String get wait => 'Aguarde...';
  @override
  String get surveys => 'Enquetes';
  @override
  String get reload => 'Recarregar';
  @override
  String get msgInvalidField => 'Campo inválido.';
  @override
  String get msgRequiredField => 'Campo obrigatório.';
  @override
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  @override
  String get msgUnexpectedError => 'Algo errado aconteceu. Tente novamente em breve.';
  @override
  String get msgEmailInUse => 'O email já esta em uso.';
}
