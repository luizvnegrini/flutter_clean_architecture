import 'package:meta/meta.dart';
import '../enums/enums.dart';

abstract class IValidation {
  ValidationError validate({@required String field, @required Map input});
}
