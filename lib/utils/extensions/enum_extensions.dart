import 'package:home_automation/domain/enums/enums.dart';

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';

      default:
        return '';
    }
  }
}
