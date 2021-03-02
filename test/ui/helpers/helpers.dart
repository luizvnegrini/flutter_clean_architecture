import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePage({@required String initialRoute, @required Widget Function() page}) {
  final getPages = [
    GetPage(name: initialRoute, page: page),
    GetPage(
        name: '/any_route',
        page: () => Scaffold(
              appBar: AppBar(title: const Text('any_title')),
              body: const Text('fake page'),
            )),
  ];

  if (initialRoute != '/login') getPages.add(GetPage(name: '/login', page: () => const Scaffold(body: Text('fake login'))));

  return GetMaterialApp(
    initialRoute: initialRoute,
    navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
    getPages: getPages,
  );
}

String get currentRoute => Get.currentRoute;
