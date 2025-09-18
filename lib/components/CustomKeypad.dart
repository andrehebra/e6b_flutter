import 'package:flutter/material.dart';

class CustomKeypad extends StatelessWidget {
  final TextEditingController controller;

  const CustomKeypad({super.key, required this.controller});

  void _addText(String text) {
    final current = controller.text;
    controller.text = current + text;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void _toggleNegative() {
    final text = controller.text;
    if (text.startsWith('-')) {
      controller.text = text.substring(1);
    } else {
      controller.text = '-$text';
    }
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void _backspace() {
    final text = controller.text;
    if (text.isNotEmpty) {
      controller.text = text.substring(0, text.length - 1);
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  void _addDecimal() {
    final text = controller.text;
    if (!text.contains('.')) {
      _addText(".");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Each row will take equal vertical space
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: _buildRow([
          ["⌫", _backspace]
        ])),
        Expanded(
            child: _buildRow([
          ["1", () => _addText("1")],
          ["2", () => _addText("2")],
          ["3", () => _addText("3")],
        ])),
        Expanded(
            child: _buildRow([
          ["4", () => _addText("4")],
          ["5", () => _addText("5")],
          ["6", () => _addText("6")],
        ])),
        Expanded(
            child: _buildRow([
          ["7", () => _addText("7")],
          ["8", () => _addText("8")],
          ["9", () => _addText("9")],
        ])),
        Expanded(
            child: _buildRow([
          ["-", _toggleNegative],
          ["0", () => _addText("0")],
          [".", _addDecimal],
        ])),
      ],
    );
  }

  Widget _buildRow(List<List<dynamic>> buttons) {
    return Row(
      children: buttons.map((b) {
        final String label = b[0];
        final VoidCallback onPressed = b[1];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
