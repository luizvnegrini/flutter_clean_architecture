import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Home automation',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      );
}
