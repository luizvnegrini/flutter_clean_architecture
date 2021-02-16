import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/ui_error.dart';
import '../../../../ui/helpers/i18n/resources.dart';
import '../../../../ui/pages/signup/signup.dart';
import '../../../../utils/extensions/enum_extensions.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ISignUpPresenter>(context);

    return StreamBuilder<UIError>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                  labelText: R.string.name,
                  errorText: snapshot.hasData ? snapshot.data.description : null,
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColorLight,
                  )),
              keyboardType: TextInputType.name,
              onChanged: presenter.validateName,
            ));
  }
}
