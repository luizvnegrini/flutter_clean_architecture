import 'package:get/state_manager.dart';

import '../../ui/helpers/errors/errors.dart';

mixin UIErrorManager on GetxController {
  final _mainError = Rx<UIError>();
  Stream<UIError> get mainErrorStream => _mainError.stream;
  set mainError(UIError value) => _mainError.value = value;
}
