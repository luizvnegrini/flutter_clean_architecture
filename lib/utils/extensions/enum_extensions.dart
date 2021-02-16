import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/helpers/i18n/resources.dart';

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;

      case UIError.invalidField:
        return R.string.msgInvalidField;

      case UIError.requiredField:
        return R.string.msgRequiredField;

      default:
        return R.string.msgUnexpectedError;
    }
  }
}
