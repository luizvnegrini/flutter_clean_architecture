import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/mixins/mixins.dart';
import './isplash_screen_presenter.dart';

class SplashScreenPage extends StatelessWidget with NavigationManager {
  final ISplashScreenPresenter presenter;

  const SplashScreenPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      appBar: AppBar(title: const Text('Splash screen')),
      body: Builder(
        builder: (context) {
          handleNavigation(presenter.navigateToStream, clear: true);

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISplashScreenPresenter>('presenter', presenter));
  }
}
