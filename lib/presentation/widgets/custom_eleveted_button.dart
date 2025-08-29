import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomElevetedWidget extends StatelessWidget {
  final void Function()? onPressed;
  final bool isAction;
  final String buttonText;
  const CustomElevetedWidget({
    super.key,
    required this.isAction,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isAction
            ? Colors.grey.shade300
            : Colors.indigo.shade500,
        foregroundColor: isAction ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: AutoSizeText(
        buttonText,
        maxLines: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
