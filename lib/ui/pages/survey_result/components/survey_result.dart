import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withAlpha(90),
              ),
              child: Text(viewModel.question),
            );
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
                  children: [
                    // ignore: prefer_if_elements_to_conditional_expressions
                    viewModel.answers[index - 1].image != null
                        ? Image.network(
                            viewModel.answers[index - 1].image,
                            width: 40,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          viewModel.answers[index - 1].answer,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Text(viewModel.answers[index - 1].percent,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        )),
                    // ignore: prefer_if_elements_to_conditional_expressions
                    viewModel.answers[index - 1].isCurrentAnswer ? ActiveIcon() : DisabledIcon(),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
          );
        },
        itemCount: viewModel.answers.length + 1,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SurveyResultViewModel>('viewModel', viewModel));
  }
}
