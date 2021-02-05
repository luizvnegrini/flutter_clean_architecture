import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

    return StreamBuilder<String>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                labelText: 'Senha',
                icon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColorLight,
                ),
                errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
              ),
              onChanged: presenter.validatePassword,
              obscureText: true,
            ));
  }
}
