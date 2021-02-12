import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home automation')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
}

void main() {
  Future<void> loadPage(WidgetTester tester) async => tester.pumpWidget(GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => SplashScreenPage(),
          )
        ],
      ));

  testWidgets('should present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
