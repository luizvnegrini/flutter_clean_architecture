import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/i18n/i18n.dart';
import './components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final ISurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter);

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

          presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) Get.offAllNamed('/login');
          });

          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return ReloadScreen(error: snapshot.error, reload: presenter.loadData);

                if (snapshot.hasData) {
                  return SurveyResult(snapshot.data);
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
