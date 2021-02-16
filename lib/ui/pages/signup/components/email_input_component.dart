import 'package:flutter/material.dart';

import '../../../../ui/helpers/i18n/resources.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: InputDecoration(
          labelText: R.string.email,
          icon: Icon(
            Icons.email,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      );
}
