import 'package:e6b_flutter/components/Calculators.dart';
import 'package:e6b_flutter/pages/phone/FunctionsList.dart';
import 'package:flutter/material.dart';

class TabletFunctionsPage extends StatefulWidget {
  const TabletFunctionsPage({super.key});

  @override
  State<TabletFunctionsPage> createState() => _TabletFunctionsPageState();
}

class _TabletFunctionsPageState extends State<TabletFunctionsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 350,
        child: FunctionsList(
          selectedIndex: _selectedIndex,
          onCalculatorSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      const VerticalDivider(width: 1),
      Expanded(
        // Wrap the calculator in a Key so it rebuilds when _selectedIndex changes
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: calculators[_selectedIndex],
        ),
      ),
    ]);
  }
}
