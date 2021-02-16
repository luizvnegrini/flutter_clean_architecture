import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../ui/helpers/i18n/resources.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
        onPressed: null,
        textColor: Colors.white,
        child: Text(R.string.enter.toUpperCase()),
      );
}
