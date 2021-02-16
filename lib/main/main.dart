import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../ui/components/components.dart';
import './factories/factories.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Home automation',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',
      getPages: [
        const GetPage(name: '/', page: makeSplashScreenPage, transition: Transition.fade),
        const GetPage(name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        const GetPage(name: '/signup', page: makeSignUpPage, transition: Transition.fadeIn),
        GetPage(name: '/home', page: () => const Scaffold(body: Text('home')), transition: Transition.fadeIn),
      ],
    );
  }
}
