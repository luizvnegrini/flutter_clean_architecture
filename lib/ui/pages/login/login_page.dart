import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'ilogin_presenter.dart';

class LoginPage extends StatelessWidget {
  final ILoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const Headline1('login'),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                    child: Column(
                  children: [
                    StreamBuilder<String>(
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
                            )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: StreamBuilder<String>(
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
                              )),
                    ),
                    StreamBuilder<bool>(
                        stream: presenter.isFormValidStream,
                        builder: (context, snapshot) => RaisedButton(
                              onPressed: snapshot.data == true ? presenter.auth : null,
                              textColor: Colors.white,
                              child: Text('Entrar'.toUpperCase()),
                            )),
                    FlatButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Criar conta'),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ILoginPresenter>('presenter', presenter));
  }
}
