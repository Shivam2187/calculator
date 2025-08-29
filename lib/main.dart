import 'package:calculator/presentation/provider/calculator_provider.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Calculator',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _controller = TextEditingController();
  final _calc = StringCalculator();
  final _scrollController = ScrollController();

  String? _resultText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_recalculate);
  }

  @override
  void dispose() {
    _controller.removeListener(_recalculate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _recalculate() {
    final input = _controller.text;
    try {
      final sum = _calc.add(input);
      setState(() {
        _resultText = sum.toString();
        _errorText = null;
      });
    } on FormatException catch (e) {
      setState(() {
        _resultText = null;
        _errorText = e.message;
      });
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            key: UniqueKey(),
            content: Text(_errorText ?? ''),
            backgroundColor: Colors.red,
          ),
        );
    } catch (e) {
      setState(() {
        _resultText = null;
        _errorText = e.toString();
      });
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            key: UniqueKey(),
            content: Text(_errorText ?? ''),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttons = CalculatorConstants.buttons;
    if (_resultText != null && _resultText!.length > 19) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            key: UniqueKey(),
            content: Text('Enter Text Limit Exceed'),
            backgroundColor: Colors.red,
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 18),
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: r'Examples: 1,2,3  or  //;\n1;2  or  1\n2,3',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              color: Colors.white,
              child: Text(
                _resultText == null ? '' : '=$_resultText',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Enter numbers separated by comma or newline!'),

            // Button Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: buttons.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    childAspectRatio: size.width / (size.height / 2.5),
                  ),
                  itemBuilder: (context, index) {
                    final text = buttons[index];
                    final isAction = ["AC", "DEL", ",", "\\n"].contains(text);

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAction
                            ? Colors.grey.shade300
                            : Colors.indigo.shade500,
                        foregroundColor: isAction ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          if (text == "AC") {
                            _controller.clear();
                            _resultText = "";
                          } else if (text == "DEL") {
                            if (_controller.text.isNotEmpty) {
                              _controller.text = _controller.text.substring(
                                0,
                                _controller.text.length - 1,
                              );
                            }
                          } else {
                            // final newText =
                            //     _controller.text +
                            //     (text == "\\n" ? "\n" : text);
                            // _controller.value = _controller.value.copyWith(
                            //   text: newText,
                            //   selection: TextSelection.collapsed(
                            //     offset: newText.length,
                            //   ),
                            // );

                            _appendText(text == "\\n" ? "\n" : text);
                          }
                        });
                      },
                      child: AutoSizeText(
                        text,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _appendText(String value) {
    final newText = _controller.text + value;
    _controller.value = _controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    // 👇 Ensure scroll jumps to the bottom after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}
