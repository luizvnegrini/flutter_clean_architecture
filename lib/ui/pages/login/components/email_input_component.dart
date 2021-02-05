import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ilogin_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

    return StreamBuilder<String>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) => TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
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
