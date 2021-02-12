import 'dart:async';

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
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) Get.offAllNamed(page);
          });

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

abstract class ISplashScreenPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}

class SplashScreenPresenterSpy extends Mock implements ISplashScreenPresenter {}

void main() {
  SplashScreenPresenterSpy presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashScreenPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);

    return tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreenPage(presenter: presenter)),
        GetPage(name: '/any_route', page: () => const Scaffold(body: Text('fake page'))),
      ],
    ));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('should present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should call LoadCurrentAccount on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });

  testWidgets('should load page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/login');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/login');
  });
}
