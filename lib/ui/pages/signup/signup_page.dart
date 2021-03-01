import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/helpers/i18n/resources.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/signup/signup.dart';

class SignUpPage extends StatelessWidget with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final ISignUpPresenter presenter;

  const SignUpPage(this.presenter);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Builder(builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  Headline1(R.string.signUp),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Provider(
                      create: (_) => presenter,
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
                            onPressed: presenter.goToLogin,
                            icon: const Icon(Icons.login),
                            label: Text(R.string.login),
                          )
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISignUpPresenter>('presenter', presenter));
  }
}
