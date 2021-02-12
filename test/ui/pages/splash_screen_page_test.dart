import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:get/route_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class SplashScreenPage extends StatelessWidget {
  final ISplashScreenPresenter presenter;

  const SplashScreenPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(title: const Text('Home automation')),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISplashScreenPresenter>('presenter', presenter));
  }
}

abstract class ISplashScreenPresenter {
  Future<void> loadCurrentAccount();
}

class SplashScreenPresenterSpy extends Mock implements ISplashScreenPresenter {}

void main() {
  SplashScreenPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashScreenPresenterSpy();

    return tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreenPage(
            presenter: presenter,
          ),
        )
      ],
    ));
  }

  testWidgets('should present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should call LoadCurrentAccount on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });
}
