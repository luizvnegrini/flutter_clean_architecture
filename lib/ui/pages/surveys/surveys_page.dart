import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_automation/ui/components/components.dart';

import '../../../ui/helpers/i18n/i18n.dart';
import '../../../ui/pages/surveys/components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';

class SurveysPage extends StatelessWidget {
  final ISurveysPresenter presenter;

  const SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
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

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CarouselSlider(
              items: const [
                SurveyItem(),
                SurveyItem(),
                SurveyItem(),
              ],
              options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISurveysPresenter>('presenter', presenter));
  }
}
