import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/i18n/i18n.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({
    @required this.error,
    @required this.reload,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: reload,
              child: Text(
                R.string.reload,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('error', error))..add(DiagnosticsProperty<Future<void> Function()>('reload', reload));
  }
}
