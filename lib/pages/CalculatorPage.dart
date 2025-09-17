import 'package:flutter/material.dart';

class CalculatorField {
  final String name;
  final String label;

  const CalculatorField({
    required this.name,
    required this.label,
  });
}

class CalculatorResult {
  final String title;
  final double? value;
  final String unit;

  const CalculatorResult({
    required this.title,
    required this.value,
    required this.unit,
  });
}

class CalculatorPage extends StatefulWidget {
  final String title;
  final List<CalculatorField> fields;
  final List<CalculatorResult> Function(Map<String, double?>) calculate;

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
  List<CalculatorResult> _results = [];

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
    final values = <String, double?>{};
    for (var entry in _controllers.entries) {
      values[entry.key] = double.tryParse(entry.value.text);
    }
    setState(() {
      _results = widget.calculate(values);
    });
  }

  String? _unitForField(String name) {
    switch (name) {
      case "indicatedAlt":
        return "ft";
      case "altimeter":
        return "inHg";
      case "temperature":
        return "°C";
      case "bankAngle":
        return "°";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var field in widget.fields)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: _controllers[field.name],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: field.label,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),

                      suffixText:
                          _unitForField(field.name), // <- helper to show units
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (_results.isNotEmpty)
                Column(
                  children: _results.map((r) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              r.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              r.value != null
                                  ? "${r.value!.toStringAsFixed(2)} ${r.unit}"
                                  : "- ${r.unit}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: r.value == null ? Colors.grey : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
