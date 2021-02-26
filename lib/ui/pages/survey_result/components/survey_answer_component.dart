import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../survey_answer_viewmodel.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      // ignore: omit_local_variable_types
      final List<Widget> children = [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              viewModel.answer,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        Text(viewModel.percent,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
            )),
        // ignore: prefer_if_elements_to_conditional_expressions
        viewModel.isCurrentAnswer ? ActiveIcon() : DisabledIcon(),
      ];

      if (viewModel.image != null) {
        children.insert(0, Image.network(viewModel.image, width: 40));
      }

      return children;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SurveyAnswerViewModel>('viewModel', viewModel));
  }
}
