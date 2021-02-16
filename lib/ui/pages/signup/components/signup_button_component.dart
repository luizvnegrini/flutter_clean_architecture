import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/signup/signup.dart';
import '../../../helpers/i18n/resources.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ISignUpPresenter>(context);

    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) => RaisedButton(
              onPressed: snapshot.data == true ? presenter.signUp : null,
              textColor: Colors.white,
              child: Text(R.string.enter.toUpperCase()),
            ));
  }
}
