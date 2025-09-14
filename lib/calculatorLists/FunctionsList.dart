import 'package:e6b_flutter/components/CalculatorCard.dart';
import 'package:flutter/material.dart';

class FunctionsList extends StatelessWidget {
  const FunctionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CalculatorCard(title: "Pressure and Density Altitude"),
        CalculatorCard(title: "Crosswind, Headwind, and Tailwind"),
        CalculatorCard(title: "Cloud Base and Freezing Level"),
        CalculatorCard(title: "Hydroplaning Speed"),
      ],
    );
  }
}
