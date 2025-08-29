import 'package:calculator/main.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorPage Widget Tests', () {
    testWidgets('renders CalculatorPage with UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CalculatorApp());

      expect(find.text('Calculator'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        find.text('Enter numbers separated by comma or newline to ADD!'),
        findsOneWidget,
      );

      // All buttons should render
      for (final button in CalculatorConstants.buttons) {
        expect(find.text(button), findsOneWidget);
      }
    });

    testWidgets('updates input when typing into TextField', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.enterText(find.byType(TextField), '1,2,3');
      await tester.pump();

      expect(find.text('1,2,3'), findsOneWidget);
    });

    testWidgets('AC clears the input', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.enterText(find.byType(TextField), '123');
      await tester.pump();

      expect(find.text('123'), findsOneWidget);

      await tester.tap(find.text('AC'));
      await tester.pump();

      expect(find.text('123'), findsNothing);
    });

    testWidgets('DEL deletes last character', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.enterText(find.byType(TextField), '123');
      await tester.pump();

      expect(find.text('123'), findsOneWidget);

      await tester.tap(find.text('DEL'));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('shows calculation result', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      await tester.enterText(find.byType(TextField), '1,2,3');
      await tester.pump();

      expect(find.text('=6'), findsOneWidget);
    });
  });
}
