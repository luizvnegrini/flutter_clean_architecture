import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/i18n/resources.dart';
import '../../../ui/mixins/mixins.dart';
import '../../components/components.dart';
import './components/components.dart';
import './ilogin_presenter.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final ILoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Builder(
          builder: (context) {
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
                    Headline1(R.string.login),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Provider(
                        create: (_) => presenter,
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
                              onPressed: presenter.goToSignUp,
                              icon: const Icon(Icons.person),
                              label: Text(R.string.addAccount),
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
    properties.add(DiagnosticsProperty<ILoginPresenter>('presenter', presenter));
  }
}
