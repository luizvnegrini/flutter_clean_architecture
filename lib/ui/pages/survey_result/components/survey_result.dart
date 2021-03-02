import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({@required String answer}) onSave;

  const SurveyResult({@required this.viewModel, @required this.onSave});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) return SurveyHeader(viewModel.question);

          final answer = viewModel.answers[index - 1];
          return GestureDetector(
            onTap: () => answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
            child: SurveyAnswer(answer),
          );
        },
        itemCount: viewModel.answers.length + 1,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<SurveyResultViewModel>('viewModel', viewModel))..add(DiagnosticsProperty<void Function()>('reload', onSave));
  }
}
