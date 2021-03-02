import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/i18n/i18n.dart';
import './components/components.dart';

class SurveyResultPage extends StatelessWidget with LoadingManager, SessionManager {
  final ISurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleSessionExpired(presenter.isSessionExpiredStream);
          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return ReloadScreen(error: snapshot.error, reload: presenter.loadData);

                if (snapshot.hasData) {
                  return SurveyResult(viewModel: snapshot.data, onSave: presenter.save);
                }

                return const SizedBox(height: 0);
              });
        },
      ));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISurveyResultPresenter>('presenter', presenter));
  }
}
