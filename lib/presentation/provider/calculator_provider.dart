import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';

class StringCalculator {
  int add(String numbers) {
    if (numbers.trim().isEmpty) return 0;

    // Default delimiters: comma or newline
    final delimiters = <String>[',', '\n'];
    String body = numbers;

    // Custom delimiter at the top? e.g. //;\n1;2   or  //[***]\n1***2***3
    if (numbers.startsWith('//')) {
      final newlineIdx = numbers.indexOf('\n');
      if (newlineIdx == -1) {
        throw FormatException(
          'Invalid input: missing newline after custom delimiter.',
        );
      }
      final header = numbers.substring(2, newlineIdx); // after // up to \n

      // single-char like ";"  OR bracketed like "[***]"
      if (header.startsWith('[') && header.endsWith(']')) {
        // support one bracketed delimiter (multi-char)
        final custom = header.substring(1, header.length - 1);
        delimiters.add(custom);
      } else {
        // single character delimiter
        delimiters.add(header);
      }

      body = numbers.substring(newlineIdx + 1); // the rest (actual numbers)
    }

    // Build a split regex from all delimiters
    final pattern = delimiters.map(RegExp.escape).join('|');
    final parts = body.split(RegExp(pattern));

    final values = <int>[];
    final negatives = <int>[];

    for (final token in parts) {
      if (token.trim().isEmpty) continue;
      final parsed = int.tryParse(token.trim());
      if (parsed == null) {
        throw FormatException('Invalid number: "$token"');
      }
      if (parsed < 0) negatives.add(parsed);
      values.add(parsed);
    }

    if (negatives.isNotEmpty) {
      // Show all negatives in the error
      throw FormatException(
        'negative numbers not allowed ${negatives.join(",")}',
      );
    }

    return values.fold<int>(0, (s, e) => s + e);
  }
}

class CalculatorProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final _calc = StringCalculator();

  String? _resultText;
  String? _errorText;

  String? get resultText => _resultText;
  String? get errorText => _errorText;

  void recalculate(BuildContext context) {
    final input = controller.text;

    try {
      final sum = _calc.add(input);
      _resultText = sum.toString();
      _errorText = null;
    } on FormatException catch (e) {
      _resultText = null;
      _errorText = e.message;
      _showSnack(context, _errorText!);
    } catch (e) {
      _resultText = null;
      _errorText = e.toString();
      _showSnack(context, _errorText!);
    }

    integerLimitCheck(context);
    notifyListeners();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          key: UniqueKey(),
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
  }

  void appendText(BuildContext context, String value) {
    final newText = controller.text + value;
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    recalculate(context);
  }

  void clear() {
    controller.clear();
    _resultText = "";
    notifyListeners();
  }

  void delete() {
    if (controller.text.isNotEmpty) {
      controller.text = controller.text.substring(
        0,
        controller.text.length - 1,
      );
      notifyListeners();
    }
  }

  void integerLimitCheck(BuildContext context) {
    if (CalculatorConstants.maxSafeInt <
        (int.tryParse(_resultText ?? '0') ?? 0)) {
      _showSnack(context, CalculatorConstants.numberNotInRange);
    }
  }
}
