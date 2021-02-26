import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:home_automation/ui/pages/surveys/components/components.dart';
import 'package:home_automation/ui/pages/surveys/surveys.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyItems(this.viewModels);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(
          items: viewModels.map((viewModel) => SurveyItem(viewModel)).toList(),
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<SurveyViewModel>('viewModels', viewModels));
  }
}
