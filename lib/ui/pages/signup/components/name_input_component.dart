import 'package:flutter/material.dart';

import '../../../helpers/i18n/resources.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: InputDecoration(
            labelText: R.string.name,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            )),
        keyboardType: TextInputType.name,
      );
}
