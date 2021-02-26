import 'package:flutter/material.dart';

class ActiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Icon(
          Icons.check_circle,
          color: Theme.of(context).highlightColor,
        ),
      );
}
