import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/i18n/i18n.dart';
import '../../../ui/pages/surveys/components/components.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(R.string.surveys),
        ),
        body: Padding(
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
        ),
      );
}