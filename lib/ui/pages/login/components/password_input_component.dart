import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/ui_error.dart';
import '../../../../ui/helpers/i18n/resources.dart';
import '../../../../utils/extensions/enum_extensions.dart';
import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

    return StreamBuilder<UIError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                labelText: R.string.password,
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColorLight,
                ),
                errorText: snapshot.hasData == true ? snapshot.data.description : null,
              ),
              onChanged: presenter.validatePassword,
              obscureText: true,
            ));
  }
}
