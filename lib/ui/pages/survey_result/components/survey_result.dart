import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) return SurveyHeader(viewModel.question);

          return SurveyAnswer(viewModel.answers[index - 1]);
        },
        itemCount: viewModel.answers.length + 1,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SurveyResultViewModel>('viewModel', viewModel));
  }
}
