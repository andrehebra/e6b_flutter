import 'package:flutter/material.dart';

class CalculatorField {
  final String name;
  final String label;

  const CalculatorField({
    required this.name,
    required this.label,
  });
}

class CalculatorPage extends StatefulWidget {
  final String title;
  final List<CalculatorField> fields;
  final String? Function(Map<String, double?>) calculate;

  const CalculatorPage({
    super.key,
    required this.title,
    required this.fields,
    required this.calculate,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final Map<String, TextEditingController> _controllers = {};
  String? _result;

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      final controller = TextEditingController();
      controller.addListener(_updateResult);
      _controllers[field.name] = controller;
    }
    _updateResult(); // initial calculation
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _updateResult() {
    final values = <String, double>{};
    for (var entry in _controllers.entries) {
      values[entry.key] = double.tryParse(entry.value.text) ?? 0.0;
    }
    setState(() {
      _result = widget.calculate(values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var field in widget.fields)
              TextField(
                controller: _controllers[field.name],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: field.label),
              ),
            const SizedBox(height: 16),
            if (_result != null)
              Text(
                "$_result",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
          ],
        ),
      ),
    );
  }
}
