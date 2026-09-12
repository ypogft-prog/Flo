import 'package:flutter_test/flutter_test.dart';
import 'package:flo/app.dart';

void main() {
  testWidgets('FLO app smoke test', (tester) async {
    await tester.pumpWidget(const FLOApp());
    expect(find.text('FLO'), findsWidgets);
    expect(find.text('خدمات FLO'), findsOneWidget);
    expect(find.text('السلة'), findsOneWidget);
  });
}
