import 'package:flutter/material.dart';

import '../../../../ui/helpers/i18n/resources.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: InputDecoration(
          labelText: R.string.password,
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        obscureText: true,
      );
}
