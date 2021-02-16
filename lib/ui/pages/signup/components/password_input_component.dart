import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/ui_error.dart';
import '../../../../ui/helpers/i18n/resources.dart';
import '../../../../ui/pages/signup/signup.dart';
import '../../../../utils/extensions/enum_extensions.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ISignUpPresenter>(context);

    return StreamBuilder<UIError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                labelText: R.string.password,
                errorText: snapshot.hasData ? snapshot.data.description : null,
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              obscureText: true,
              onChanged: presenter.validatePassword,
            ));
  }
}
