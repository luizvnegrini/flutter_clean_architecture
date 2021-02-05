import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ilogin_presenter.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ILoginPresenter>(context);

    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) => RaisedButton(
              onPressed: snapshot.data == true ? presenter.auth : null,
              textColor: Colors.white,
              child: Text('Entrar'.toUpperCase()),
            ));
  }
}
