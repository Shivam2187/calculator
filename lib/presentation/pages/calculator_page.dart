import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/calculator_provider.dart';
import '../../utils/constants.dart';
import '../widgets/calulator_custom_textfield.dart';
import '../widgets/custom_eleveted_button.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttons = CalculatorConstants.buttons;

    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(CalculatorConstants.calculator),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<CalculatorProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CalulatorCustomTextfield(
                      controller: provider.controller,
                      onChanged: (_) => provider.recalculate(context),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      width: double.infinity,
                      color: Colors.white,
                      child: Text(
                        provider.resultText == null
                            ? ''
                            : '=${provider.resultText}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(CalculatorConstants.helperText),
                    Padding(
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
                          final isAction = [
                            CalculatorConstants.actionClear,
                            CalculatorConstants.actionDelete,
                            CalculatorConstants.actionComma,
                            CalculatorConstants.actionNewLine,
                          ].contains(text);

                          return CustomElevetedWidget(
                            buttonText: text,
                            isAction: isAction,
                            onPressed: () {
                              if (text == CalculatorConstants.actionClear) {
                                provider.clear();
                              } else if (text ==
                                  CalculatorConstants.actionDelete) {
                                provider.delete();
                              } else {
                                provider.appendText(
                                  context,
                                  text == CalculatorConstants.actionNewLine
                                      ? "\n"
                                      : text,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
