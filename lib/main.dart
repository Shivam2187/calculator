import 'package:calculator/presentation/provider/calculator_provider.dart';
import 'package:calculator/presentation/widgets/calulator_custom_textfield.dart';
import 'package:calculator/presentation/widgets/custom_eleveted_button.dart';
import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            key: UniqueKey(),
            content: Text(_errorText ?? ''),
            backgroundColor: Colors.red,
          ),
        );
      integerLimitCheck();
      setState(() {
        _resultText = null;
        _errorText = e.message;
      });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(CalculatorConstants.calculator),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CalulatorCustomTextfield(
              controller: _controller,
              onChanged: (value) => integerLimitCheck,
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(CalculatorConstants.helperText),

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

                    return CustomElevetedWidget(
                      onPressed: () {
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
                            _appendText(text == "\\n" ? "\n" : text);
                          }
                        });
                      },
                      buttonText: text,
                      isAction: isAction,
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

  void integerLimitCheck() {
    if (CalculatorConstants.maxSafeInt <
        (int.tryParse(_resultText ?? '0') ?? 0)) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            key: UniqueKey(),
            content: Text(CalculatorConstants.numberNotInRange),
            backgroundColor: Colors.red,
          ),
        );
    }
  }
}
