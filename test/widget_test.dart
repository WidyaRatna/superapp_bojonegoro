import 'package:flutter_test/flutter_test.dart';
import 'package:superapp_bojonegoro/main.dart';

void main() {
  testWidgets('SuperApp Bojonegoro smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SuperAppBojonegoro());
    expect(find.text('Selamat datang di'), findsOneWidget);
    expect(find.text('Kab. Bojonegoro'), findsOneWidget);
  });
}
