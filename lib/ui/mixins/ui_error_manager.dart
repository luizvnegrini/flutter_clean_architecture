import 'package:flutter/material.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../utils/extensions/enum_extensions.dart';
import '../components/components.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError> stream) {
    stream.listen((error) {
      if (error != null) showErrorMessage(context, error.description);
    });
  }
}
