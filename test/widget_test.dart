import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms/main.dart';

void main() {
  testWidgets('App should render login page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WMSApp()),
    );
    await tester.pump();

    expect(find.text('企业进销存管理系统'), findsWidgets);
    expect(find.text('登 录'), findsOneWidget);
  });
}
