import 'package:calculator/presentation/provider/calculator_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StringCalculator calc;

  setUp(() {
    calc = StringCalculator();
  });

  test('empty string returns 0', () {
    expect(calc.add(''), 0);
  });

  test('single number', () {
    expect(calc.add('1'), 1);
  });

  test('two numbers comma separated', () {
    expect(calc.add('1,5'), 6);
  });

  test('any amount of numbers', () {
    expect(calc.add('1,2,3,4,5'), 15);
  });

  test('newlines between numbers', () {
    expect(calc.add('1\n2,3'), 6);
  });

  test('custom delimiter single-char', () {
    expect(calc.add('//;\n1;2;3'), 6);
  });

  test('custom delimiter multi-char in brackets', () {
    expect(calc.add('//[***]\n1***2***3'), 6);
  });

  test('throws on negative single', () {
    expect(
      () => calc.add('1,-2,3'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('negative numbers not allowed -2'),
        ),
      ),
    );
  });

  test('throws and lists all negatives', () {
    expect(
      () => calc.add('-1,2,-3\n4'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('negative numbers not allowed -1,-3'),
        ),
      ),
    );
  });
}
