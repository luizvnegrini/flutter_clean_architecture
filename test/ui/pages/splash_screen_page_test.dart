import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class SplashScreenPresenterSpy extends Mock implements ISplashScreenPresenter {}

void main() {
  SplashScreenPresenterSpy presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashScreenPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);

    await tester.pumpWidget(makePage(initialRoute: '/', page: () => SplashScreenPage(presenter)));
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

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('should load page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/');
  });
}
