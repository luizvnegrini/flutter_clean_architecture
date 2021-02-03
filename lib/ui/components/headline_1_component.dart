import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Headline1 extends StatelessWidget {
  final String text;

  const Headline1(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontFamily: 'Rubik',
            ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}
