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
