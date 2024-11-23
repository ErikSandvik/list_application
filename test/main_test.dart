import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_application/main.dart';
import 'package:list_application/list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches and displays initial lists', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'tabs': ['Dagligvarer', 'TODO-liste', 'Utstyr'],
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final rootElement = tester.binding.rootElement;
    if (rootElement != null) {
      debugPrint(rootElement.toStringDeep());
    } else {
      debugPrint('Root element is null');
    }

    expect(find.text('Dagligvarer'), findsOneWidget);
    expect(find.text('TODO-liste'), findsOneWidget);
    expect(find.text('Utstyr'), findsOneWidget);

    final addButton = find.byTooltip('Legg til ny liste');
    expect(addButton, findsOneWidget);
  });

  testWidgets('Add new list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'tabs': ['Dagligvarer']});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Legg til ny liste'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogTextField, 'Hytteutstyr');

    final dialogAddButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Legg til'),
    );
    await tester.tap(dialogAddButton);
    await tester.pumpAndSettle();

    expect(find.text('Hytteutstyr'), findsOneWidget);
  });


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

  testWidgets('Add a new list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'tabs': ['Dagligvarer']});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Legg til ny liste'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogTextField, 'Hytteutstyr');

    final addButtonInDialog = find.descendant(
      of: find.byWidgetPredicate(
            (widget) => widget is AlertDialog,
      ),
      matching: find.widgetWithText(TextButton, 'Legg til'),
    );
    await tester.tap(addButtonInDialog);
    await tester.pumpAndSettle();

    expect(find.text('Hytteutstyr'), findsOneWidget);
  });


  testWidgets('Delete an existing list', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'tabs': ['Dagligvarer', 'TODO-liste']});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('TODO-liste'));
    await tester.pumpAndSettle();

    final deleteButton = find.descendant(
      of: find.byType(TabBarView),
      matching: find.widgetWithIcon(FloatingActionButton, Icons.delete),
    );
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    final confirmDeleteButton = find.widgetWithText(TextButton, 'Slett');
    expect(confirmDeleteButton, findsOneWidget);
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle();

    expect(find.text('TODO-liste'), findsNothing);
    expect(find.text('Dagligvarer'), findsOneWidget);
  });

  testWidgets('Prevent adding duplicate lists', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'tabs': ['Dagligvarer']});

    await tester.pumpWidget(MaterialApp(home: const MyApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Legg til ny liste'));
    await tester.pumpAndSettle();

    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogTextField, 'Dagligvarer');
    await tester.pumpAndSettle();

    final dialogAddButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Legg til'),
    );
    await tester.tap(dialogAddButton);
    await tester.pumpAndSettle();

    final listItems = find.text('Dagligvarer');
    expect(listItems, findsOneWidget);
  });

}