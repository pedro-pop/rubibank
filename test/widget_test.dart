import 'package:flutter_test/flutter_test.dart';
import 'package:rubibank/main.dart';

void main() {
  testWidgets('RubiBank smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RubiBankApp());
  });
}
