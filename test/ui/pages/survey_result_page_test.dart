import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/ui/pages/surveys/survey_viewmodel.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/ui/pages/pages.dart';
import 'package:home_automation/utils/extensions/enum_extensions.dart';

class SurveyResultPresenterSpy extends Mock implements ISurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<dynamic> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<dynamic>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter)),
      ],
    );

    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  setUp(() {
    presenter = SurveyResultPresenterSpy();
    isLoadingController = StreamController();
  });

  tearDown(() {
    isLoadingController.close();
    surveyResultController.close();
  });

  testWidgets('should call LoadSurveyResult on page load', (WidgetTester tester) async {
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

  testWidgets('should present error if surveyResultStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
  });
}
