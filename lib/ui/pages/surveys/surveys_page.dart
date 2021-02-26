import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../../ui/helpers/i18n/i18n.dart';
import '../../../ui/pages/surveys/components/survey_items_component.dart';
import '../../../ui/pages/surveys/surveys.dart';

class SurveysPage extends StatelessWidget {
  final ISurveysPresenter presenter;

  const SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(R.string.surveys),
        ),
        body: Builder(
          builder: (context) {
            presenter.isLoadingStream.listen((isLoading) {
              if (isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            });
            presenter.loadData();

            return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error,
                    reload: presenter.loadData,
                  );
                }

                if (snapshot.hasData) return SurveyItems(snapshot.data);

                return const SizedBox(height: 0);
              },
            );
          },
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISurveysPresenter>('presenter', presenter));
  }
}
