import 'package:e6b_flutter/components/CalculatorCard.dart';
import 'package:e6b_flutter/components/Calculators.dart';
import 'package:flutter/material.dart';

class FunctionsList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCalculatorSelected;

  const FunctionsList(
      {Key? key,
      required this.selectedIndex,
      required this.onCalculatorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: calculators.length,
      itemBuilder: (context, index) {
        return CalculatorCard(
          title: calculators[index].title,
          onTap: () => onCalculatorSelected(index),
        );
      },
    );
  }
}


/*ListView(
      children: [
        CalculatorCard(
          title: "Pressure and Density Altitude",
        ),
        CalculatorCard(title: "Crosswind, Headwind, and Tailwind"),
        CalculatorCard(title: "Cloud Base and Freezing Level"),
        CalculatorCard(title: "Hydroplaning Speed"),
      ],
    );
    
    */