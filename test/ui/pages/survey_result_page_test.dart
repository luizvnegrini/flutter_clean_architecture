import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

import 'package:home_automation/ui/helpers/errors/errors.dart';
import 'package:home_automation/ui/helpers/i18n/i18n.dart';
import 'package:home_automation/ui/pages/pages.dart';
import 'package:home_automation/utils/extensions/enum_extensions.dart';

import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock implements ISurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    when(presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  SurveyResultViewModel makeSurveyResult() => const SurveyResultViewModel(
        surveyId: 'Any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
            image: 'Image 0',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();

    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(makePage(initialRoute: '/survey_result/any_survey_id', page: () => SurveyResultPage(presenter)));
    });
  }

  setUp(() {
    presenter = SurveyResultPresenterSpy();
    isLoadingController = StreamController();
  });

  tearDown(() {
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
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
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('should call LoadSurveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.string.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should present valid data if surveyResultStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

  testWidgets('should logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();
    expect(currentRoute, '/survey_result/any_survey_id');

    isSessionExpiredController.add(null);
    await tester.pumpAndSettle();
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('should call save on list item click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 1'));

    verify(presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('should not call save on current answer click', (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(makeSurveyResult());
    await provideMockedNetworkImages(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 0'));

    verifyNever(presenter.save(answer: 'Answer 0'));
  });
}
