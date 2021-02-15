import 'package:home_automation/ui/helpers/errors/ui_error.dart';

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return 'Credenciais inválidas.';

      case UIError.invalidField:
        return 'Campo inválido.';

      case UIError.requiredField:
        return 'Campo obrigatório.';

      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}
