import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import './components/components.dart';
import 'ilogin_presenter.dart';

class LoginPage extends StatefulWidget {
  final ILoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ILoginPresenter>('presenter', presenter));
  }
}

class _LoginPageState extends State<LoginPage> {
  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  @override
  void dispose() {
    super.dispose();

    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Builder(
          builder: (context) {
            widget.presenter.isLoadingStream.listen((isLoading) {
              if (isLoading) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            });

            widget.presenter.mainErrorStream.listen((error) {
              if (error != null) {
                showErrorMessage(context, error);
              }
            });

            return GestureDetector(
              onTap: _hideKeyboard,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const LoginHeader(),
                    const Headline1('login'),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Provider(
                        create: (_) => widget.presenter,
                        child: Form(
                            child: Column(
                          children: [
                            EmailInput(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 30),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            FlatButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.person),
                              label: const Text('Criar conta'),
                            )
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ILoginPresenter>('presenter', widget.presenter));
  }
}
