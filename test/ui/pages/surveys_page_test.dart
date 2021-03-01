import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/ui/helpers/i18n/i18n.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/ui/pages/pages.dart';
import 'package:home_automation/ui/pages/surveys/surveys.dart';
import 'package:home_automation/utils/extensions/enum_extensions.dart';

class SurveysPresenterSpy extends Mock implements ISurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<String> navigateToController;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => loadSurveysController.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
        GetPage(name: '/any_route', page: () => const Scaffold(body: Text('fake page'))),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        const SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        const SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  setUp(() {
    presenter = SurveysPresenterSpy();
  });

  void closeStream() {
    isLoadingController.close();
    loadSurveysController.close();
    navigateToController.close();
  }

  tearDown(closeStream);

  testWidgets('should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present error if surveysStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should present list if surveysStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.string.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click', (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}
