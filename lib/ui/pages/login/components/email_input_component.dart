import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/errors/ui_error.dart';
import '../../../../utils/extensions/enum_extensions.dart';
import '../ilogin_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: snapshot.hasData ? snapshot.data.description : null,
                icon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              onChanged: presenter.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ));
  }
}
