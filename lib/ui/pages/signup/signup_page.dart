import 'package:flutter/material.dart';
import 'package:home_automation/ui/helpers/i18n/resources.dart';

import '../../components/components.dart';
import './components/components.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
    }

    return Scaffold(
      body: Builder(
          builder: (context) => GestureDetector(
                onTap: _hideKeyboard,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginHeader(),
                      Headline1(R.string.signUp),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                            child: Column(
                          children: [
                            NameInput(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: EmailInput(),
                            ),
                            PasswordInput(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 32),
                              child: PasswordConfirmationInput(),
                            ),
                            SignUpButton(),
                            FlatButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.login),
                              label: Text(R.string.login),
                            )
                          ],
                        )),
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
