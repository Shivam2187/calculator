import 'package:calculator/utils/constants.dart';
import 'package:flutter/material.dart';

class CalulatorCustomTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const CalulatorCustomTextfield({super.key, this.controller, this.onChanged});

  @override
  State<CalulatorCustomTextfield> createState() =>
      _CalulatorCustomTextfieldState();
}

class _CalulatorCustomTextfieldState extends State<CalulatorCustomTextfield> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(
      _scrollToEnd,
    ); // auto-scroll whenever text changes
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_scrollToEnd);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      scrollController: _scrollController,
      style: const TextStyle(fontSize: 18),
      autofocus: true,
      maxLines: 3,
      minLines: 2,
      decoration: InputDecoration(
        hintText: CalculatorConstants.hintText,
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
      onChanged: widget.onChanged,
    );
  }
}
