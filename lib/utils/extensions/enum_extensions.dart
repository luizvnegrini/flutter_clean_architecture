import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/helpers/i18n/resources.dart';

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;

      case UIError.invalidField:
        return R.strings.msgInvalidField;

      case UIError.requiredField:
        return R.strings.msgRequiredField;

      default:
        return R.strings.msgUnexpectedError;
    }
  }
}
