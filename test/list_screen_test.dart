import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_application/list_screen.dart';
import 'package:list_application/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Mark entry as completed', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'tabs': ['Dagligvarer']});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final listTextField = find.descendant(
      of: find.byType(ListScreen),
      matching: find.byType(TextField),
    );
    await tester.enterText(listTextField, 'Egg');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Egg'));
    await tester.pumpAndSettle();

    final completedEntry = find.descendant(
      of: find.byType(ListScreen),
      matching: find.text('Egg'),
    );
    expect(completedEntry, findsOneWidget);
  });
}
