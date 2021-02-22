import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:home_automation/ui/pages/pages.dart';
import 'package:home_automation/ui/pages/surveys/isurveys_presenter.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements ISurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;

  setUp(() {
    presenter = SurveysPresenterSpy();
  });

  testWidgets('should call LoadSurveys on page load', (WidgetTester tester) async {
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
      ],
    );

    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
